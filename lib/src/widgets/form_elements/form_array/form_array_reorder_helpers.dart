// PoC Implementation of a custom reorder controller for array items
// need refactoring so no code duplication with the existing reorderable list implementation

part of 'form_array_field.dart';

class _ArrayReorderDelegate {
  _ArrayReorderDelegate({
    required List<ListItem> Function() getItems,
    required BuildContext Function() getContext,
    required FormFieldContext Function() getFormFieldContext,
    required void Function(VoidCallback fn) setState,
    required VoidCallback notifyItemsChanged,
    required bool Function() isMounted,
    required void Function(int index) removeItem,
  })  : _getItems = getItems,
        _getContext = getContext,
        _getFormFieldContext = getFormFieldContext,
        _setState = setState,
        _notifyItemsChanged = notifyItemsChanged,
        _isMounted = isMounted,
        _removeItem = removeItem,
        _scrollController = const _ArrayReorderScrollController() {
    controller = _CustomArrayReorderController(
      getItems: getItems,
      setState: setState,
      ensureHeaderVisible: _ensureHeaderVisible,
      notifyItemsChanged: notifyItemsChanged,
    );
  }

  final List<ListItem> Function() _getItems;
  final BuildContext Function() _getContext;
  final FormFieldContext Function() _getFormFieldContext;
  final void Function(VoidCallback fn) _setState;
  final VoidCallback _notifyItemsChanged;
  final bool Function() _isMounted;
  final void Function(int index) _removeItem;
  final _ArrayReorderScrollController _scrollController;
  final GlobalKey _headerKey = GlobalKey(debugLabel: 'FormArrayFieldHeader');
  late final _CustomArrayReorderController controller;

  GlobalKey get headerKey => _headerKey;

  void ensureHeaderVisible() => _ensureHeaderVisible();

  Widget buildCustomList({
    required int minItems,
    bool collapseWhileReordering = false,
  }) {
    final List<Widget> children = [];
    final bool showDropZones = controller.isReordering;
    final List<ListItem> items = _getItems();

    if (showDropZones) {
      for (int targetIndex = 0; targetIndex <= items.length; targetIndex++) {
        children.add(_buildDropZone(targetIndex));
        if (targetIndex < items.length) {
          children.add(
            buildArrayItemWidget(
              item: items[targetIndex],
              index: targetIndex,
              minItems: minItems,
              collapseWhileReordering: collapseWhileReordering,
              useCustomReorder: true,
            ),
          );
        }
      }
    } else {
      for (int index = 0; index < items.length; index++) {
        children.add(
          buildArrayItemWidget(
            item: items[index],
            index: index,
            minItems: minItems,
            collapseWhileReordering: collapseWhileReordering,
            useCustomReorder: true,
          ),
        );
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
  }

  Widget buildArrayItemWidget({
    required ListItem<dynamic> item,
    required int index,
    required int minItems,
    required bool collapseWhileReordering,
    required bool useCustomReorder,
  }) {
    final FormFieldContext parentContext = _getFormFieldContext();
    final ui.DescendantControlOverrides? overrides = parentContext.options?.formattingOptions?.descendantControlOverrides?[parentContext.scope];
    final ui.Options? childOptions = overrides?.options ?? parentContext.options;
    final ui.ShowOnProperty? childShowOn = overrides?.showOn;
    final JsonSchema childSchema = parentContext.jsonSchema.items!;
    final bool childIsObjectType = _schemaRepresentsObject(childSchema);
    final bool childIsPrimitive = _schemaIsPrimitive(childSchema);

    final childSelfIndices = () {
      final map = <String, int>{};
      if (parentContext.selfIndices != null) {
        map.addAll(parentContext.selfIndices!);
      }
      map[parentContext.scope] = index;
      return map;
    }();

    final childContext = parentContext.createChildContext(
      childScope: '${parentContext.scope}/items',
      childId: '${parentContext.id}/items/${item.id}',
      childJsonSchema: childSchema,
      childInitialValue: item.value,
      childRequired: parentContext.required,
      childShowLabel: false,
      childOptions: childOptions,
      childShowOn: childShowOn,
      childSelfIndices: childSelfIndices,
      childShowObjectLeadingLine: childIsObjectType ? false : null,
      childOnChanged: (value) {
        final items = _getItems();
        items[index].value = value;
        _notifyItemsChanged();
        _setState(() {});
      },
      childOnSavedCallback: (value, {Map<String, int>? computedSelfIndices}) {
        final items = _getItems();
        items[index].value = value;
        if (parentContext.onSavedCallback != null && index == items.length - 1) {
          parentContext.onSavedCallback!(
            items.map((e) => e.value).toList(),
            computedSelfIndices: childSelfIndices,
          );
        }
      },
    );

    final ThemeData theme = Theme.of(_getContext());
    final bool canRemove = _getItems().length > minItems;
    final bool isReordering = controller.isReordering;
    final bool isActiveDragged = isReordering && controller.activeDraggedItemIndex == index;
    final bool collapseForThisItem = useCustomReorder && collapseWhileReordering && isReordering && !childIsPrimitive && !isActiveDragged;
    final String collapsedLabelBase = _getArrayItemLabelBase(parentContext, childContext: childContext);
    final String collapsedLabel = '$collapsedLabelBase #${index + 1}';

    const double sideActionWidth = 35.0;
    const double sideActionGap = 8.0;

    Widget buildCollapsedChild({required bool isActive}) {
      return _buildCollapsedArrayItemPreview(
        theme: theme,
        label: collapsedLabel,
        index: index,
        isActive: isActive,
      );
    }

    Widget buildExpandedChild({
      bool includeSideActions = true,
      bool actionsInteractive = true,
      Widget Function()? dragPreviewBuilder,
    }) {
      return SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: includeSideActions ? sideActionWidth : 0.0),
              child: FormElementFactory.createFormElement(childContext),
            ),
            if (includeSideActions)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: sideActionWidth,
                child: _buildReorderAction(
                  theme: theme,
                  gap: sideActionGap,
                  index: index,
                  label: collapsedLabel,
                  useCustomReorder: useCustomReorder,
                  dragPreviewBuilder: dragPreviewBuilder,
                  enableInteraction: actionsInteractive,
                ),
              ),
            if (includeSideActions)
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                width: sideActionWidth,
                child: _buildDeleteAction(
                  theme: theme,
                  index: index,
                  canRemove: canRemove,
                  gap: sideActionGap,
                  itemId: item.id,
                  enableInteraction: actionsInteractive,
                  parentContext: parentContext,
                ),
              ),
          ],
        ),
      );
    }

    Widget buildPrimitiveDragPreview() {
      return IgnorePointer(
        child: buildExpandedChild(
          actionsInteractive: false,
          dragPreviewBuilder: null,
        ),
      );
    }

    Widget buildDragPreview() {
      if (childIsPrimitive) {
        return buildPrimitiveDragPreview();
      }
      return buildCollapsedChild(isActive: true);
    }

    final Widget expandedChild = buildExpandedChild(
      dragPreviewBuilder: useCustomReorder ? () => buildDragPreview() : null,
    );
    final Widget collapsedChild = buildCollapsedChild(isActive: isActiveDragged);
    final Widget animatedContent = _buildAnimatedItemContainer(
      keyPrefix: '${parentContext.id}/items/${item.id}',
      expandedChild: expandedChild,
      collapsedChild: collapsedChild,
      showCollapsedState: collapseForThisItem,
    );

    final Widget interactiveContent = useCustomReorder
        ? AnimatedSwitcher(
            duration: const Duration(milliseconds: 120),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: isActiveDragged ? const SizedBox.shrink() : animatedContent,
          )
        : animatedContent;

    if (!useCustomReorder) {
      return interactiveContent;
    }

    return LongPressDraggable<_DragPayload>(
      data: _DragPayload(index: index, listIdentity: controller.listIdentity),
      axis: Axis.vertical,
      maxSimultaneousDrags: 1,
      hapticFeedbackOnStart: true,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: _buildDragFeedback(
        theme: theme,
        preview: buildDragPreview(),
      ),
      onDragStarted: () => controller.handleDragStart(index),
      onDragEnd: (details) => controller.handleDragEnd(details),
      onDraggableCanceled: (_, __) => controller.handleDragCancel(),
      onDragUpdate: (details) => controller.handleDragUpdate(details.globalPosition),
      childWhenDragging: const SizedBox.shrink(),
      child: interactiveContent,
    );
  }

  void _ensureHeaderVisible() {
    if (!_scrollController.shouldScroll(headerKey: _headerKey)) {
      return;
    }
    _scrollController.ensureHeaderVisible(
      headerKey: _headerKey,
      isMounted: _isMounted,
    );
  }

  Widget _buildReorderAction({
    required ThemeData theme,
    required double gap,
    required int index,
    required String label,
    required bool useCustomReorder,
    Widget Function()? dragPreviewBuilder,
    bool enableInteraction = true,
  }) {
    final Color outline = theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
    final Color background = theme.colorScheme.surfaceContainerHighest.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.35 : 0.7,
    );

    return Padding(
      padding: EdgeInsets.only(right: gap),
      child: IgnorePointer(
        ignoring: !enableInteraction,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: outline),
          ),
          child: _buildHandleDraggable(
            index: index,
            theme: theme,
            label: label,
            useCustomReorder: useCustomReorder,
            dragPreviewBuilder: dragPreviewBuilder,
            enableInteraction: enableInteraction,
          ),
        ),
      ),
    );
  }

  Widget _buildHandleDraggable({
    required int index,
    required ThemeData theme,
    required String label,
    required bool useCustomReorder,
    Widget Function()? dragPreviewBuilder,
    required bool enableInteraction,
  }) {
    Widget buildSlot({double opacity = 1.0}) {
      return Opacity(
        opacity: opacity,
        child: _ArrayActionSlot(
          icon: Icons.drag_indicator_rounded,
          iconColor: theme.colorScheme.primary,
          tooltip: _getContext().localize((l) => l.buttonDragHandle),
          onTap: () => FocusScope.of(_getContext()).unfocus(),
        ),
      );
    }

    if (!enableInteraction) {
      return buildSlot();
    }

    if (!useCustomReorder) {
      return Listener(
        onPointerDown: (_) => ensureHeaderVisible(),
        child: ReorderableDragStartListener(
          index: index,
          child: buildSlot(),
        ),
      );
    }

    return Draggable<_DragPayload>(
      data: _DragPayload(index: index, listIdentity: controller.listIdentity),
      axis: Axis.vertical,
      maxSimultaneousDrags: 1,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: _buildDragFeedback(
        theme: theme,
        preview: dragPreviewBuilder?.call() ?? const SizedBox.shrink(),
      ),
      onDragStarted: () => controller.handleDragStart(index),
      onDragEnd: (details) => controller.handleDragEnd(details),
      onDraggableCanceled: (_, __) => controller.handleDragCancel(),
      onDragUpdate: (details) => controller.handleDragUpdate(details.globalPosition),
      childWhenDragging: const SizedBox.shrink(),
      child: buildSlot(),
    );
  }

  Widget _buildDeleteAction({
    required ThemeData theme,
    required int index,
    required bool canRemove,
    required double gap,
    required int itemId,
    required FormFieldContext parentContext,
    bool enableInteraction = true,
  }) {
    final Color outline = theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
    final Color background = theme.colorScheme.surfaceContainerHighest.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.35 : 0.7,
    );

    return Padding(
      padding: EdgeInsets.only(left: gap),
      child: IgnorePointer(
        ignoring: !enableInteraction,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: outline),
          ),
          child: _ArrayActionSlot(
            key: Key('${parentContext.id}/$itemId/remove'),
            icon: Icons.delete_outline,
            iconColor: theme.colorScheme.error,
            tooltip: _getContext().localize((l) => l.buttonRemove),
            onTap: canRemove ? () => _removeItem(index) : null,
          ),
        ),
      ),
    );
  }

  Widget _buildDropZone(int targetIndex) {
    if (!controller.isReordering) {
      return const SizedBox.shrink();
    }

    final ThemeData theme = Theme.of(_getContext());
    final List<ListItem> items = _getItems();
    final bool isEdge = targetIndex == 0 || targetIndex == items.length;
    final double baseHeight = isEdge ? 18.0 : 36.0;
    final bool isActive = controller.currentDropIndex == targetIndex;
    final int? activeIndex = controller.activeDraggedItemIndex;
    final bool skipForDraggedItem = activeIndex != null && targetIndex == activeIndex + 1;

    if (skipForDraggedItem) {
      return const SizedBox.shrink();
    }

    final GlobalKey zoneKey = controller.dropZoneKeyForIndex(targetIndex, _getFormFieldContext().id);

    return DragTarget<_DragPayload>(
      key: zoneKey,
      hitTestBehavior: HitTestBehavior.translucent,
      onWillAcceptWithDetails: (details) {
        final payload = details.data;
        if (payload.listIdentity != controller.listIdentity) {
          return false;
        }
        controller.markDropIndex(targetIndex);
        return true;
      },
      onAcceptWithDetails: (details) => controller.handleDrop(details.data.index, targetIndex),
      builder: (context, candidateData, rejectedData) {
        final bool showHighlight = isActive || candidateData.isNotEmpty;
        final Color highlightColor = theme.colorScheme.primary.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.25 : 0.15,
        );

        final double spacingHeight = isEdge ? 6.0 : 18.0;
        final double effectiveHeight = showHighlight ? baseHeight : spacingHeight;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeInOut,
          height: effectiveHeight,
          margin: EdgeInsets.symmetric(vertical: isEdge ? 2.0 : 6.0),
          decoration: BoxDecoration(
            color: showHighlight ? highlightColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: showHighlight ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.6)) : null,
          ),
        );
      },
    );
  }

  Widget _buildDragFeedback({
    required ThemeData theme,
    required Widget preview,
  }) {
    return Material(
      elevation: 6.0,
      color: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: IgnorePointer(child: preview),
      ),
    );
  }

  Widget _buildCollapsedArrayItemPreview({
    required ThemeData theme,
    required String label,
    required int index,
    required bool isActive,
  }) {
    final Color outline = theme.colorScheme.outlineVariant;
    final Color base = theme.colorScheme.surfaceContainerHighest.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.25 : 0.7,
    );
    final Color background = isActive ? theme.colorScheme.primary.withValues(alpha: 0.08) : base;
    final Color textColor = theme.colorScheme.onSurfaceVariant;

    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: outline),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: [
            Icon(Icons.drag_indicator_rounded, color: textColor.withValues(alpha: 0.8)),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              '#${index + 1}',
              style: theme.textTheme.labelLarge?.copyWith(color: textColor.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedItemContainer({
    required String keyPrefix,
    required Widget expandedChild,
    required Widget collapsedChild,
    required bool showCollapsedState,
  }) {
    final Widget activeChild = showCollapsedState ? collapsedChild : expandedChild;

    return KeyedSubtree(
      key: Key('$keyPrefix/${showCollapsedState ? 'collapsed' : 'expanded'}'),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          child: activeChild,
        ),
      ),
    );
  }
}

class _DragPayload {
  const _DragPayload({required this.index, required this.listIdentity});

  final int index;
  final Object listIdentity;
}

class _CustomArrayReorderController {
  _CustomArrayReorderController({
    required List<ListItem> Function() getItems,
    required void Function(VoidCallback fn) setState,
    required VoidCallback ensureHeaderVisible,
    required VoidCallback notifyItemsChanged,
  })  : _getItems = getItems,
        _setState = setState,
        _ensureHeaderVisible = ensureHeaderVisible,
        _notifyItemsChanged = notifyItemsChanged;

  final List<ListItem> Function() _getItems;
  final void Function(VoidCallback fn) _setState;
  final VoidCallback _ensureHeaderVisible;
  final VoidCallback _notifyItemsChanged;

  bool _isReordering = false;
  int? _activeDraggedItemIndex;
  int? _currentDropIndex;
  final Map<int, GlobalKey> _dropZoneKeys = {};
  final Object _listIdentity = Object();

  bool get isReordering => _isReordering;
  int? get activeDraggedItemIndex => _activeDraggedItemIndex;
  int? get currentDropIndex => _currentDropIndex;
  Object get listIdentity => _listIdentity;

  void handleDragStart(int index) {
    _setState(() {
      _isReordering = true;
      _activeDraggedItemIndex = index;
      _currentDropIndex = index;
    });
    _ensureHeaderVisible();
  }

  void handleMaterialReorderStart(int index) {
    _setState(() {
      _isReordering = true;
      _activeDraggedItemIndex = index;
      _currentDropIndex = null;
    });
    _ensureHeaderVisible();
  }

  void handleDragUpdate(Offset globalPosition) {
    if (!_isReordering) {
      return;
    }

    int? closestIndex;
    double closestDistance = double.infinity;

    _dropZoneKeys.forEach((index, key) {
      final BuildContext? context = key.currentContext;
      if (context == null) {
        return;
      }
      final RenderObject? renderObject = context.findRenderObject();
      if (renderObject is! RenderBox) {
        return;
      }

      final Offset topLeft = renderObject.localToGlobal(Offset.zero);
      final Size size = renderObject.size;
      final double centerY = topLeft.dy + size.height / 2;
      final double distance = (globalPosition.dy - centerY).abs();
      if (distance < closestDistance) {
        closestDistance = distance;
        closestIndex = index;
      }
    });

    if (closestIndex != null && closestIndex != _currentDropIndex) {
      _setState(() {
        _currentDropIndex = closestIndex;
      });
    }
  }

  void handleDragEnd(DraggableDetails details) => _resolveDragEnd(wasAccepted: details.wasAccepted);

  void handleDragCancel() => _resolveDragEnd(wasAccepted: false);

  void handleDrop(int fromIndex, int targetIndex) {
    _performReorder(fromIndex, targetIndex);
    resetDragState();
  }

  void markDropIndex(int targetIndex) {
    if (!_isReordering || _currentDropIndex == targetIndex) {
      return;
    }
    _setState(() {
      _currentDropIndex = targetIndex;
    });
  }

  GlobalKey dropZoneKeyForIndex(int index, String scopeId) {
    return _dropZoneKeys.putIfAbsent(
      index,
      () => GlobalKey(debugLabel: '$scopeId/drop_zone/$index'),
    );
  }

  void resetDragState() {
    if (!_isReordering && _activeDraggedItemIndex == null && _currentDropIndex == null) {
      _dropZoneKeys.clear();
      return;
    }
    _setState(_clearDragFlags);
  }

  void _resolveDragEnd({required bool wasAccepted}) {
    if (!wasAccepted && _activeDraggedItemIndex != null && _currentDropIndex != null) {
      _performReorder(_activeDraggedItemIndex!, _currentDropIndex!);
    }
    resetDragState();
  }

  bool _performReorder(int fromIndex, int targetIndex) {
    final List<ListItem> items = _getItems();
    final int itemCount = items.length;
    if (fromIndex < 0 || fromIndex >= itemCount) {
      return false;
    }

    final bool noMovement = targetIndex == fromIndex || targetIndex == fromIndex + 1;
    if (noMovement) {
      return false;
    }

    _setState(() {
      final ListItem item = items.removeAt(fromIndex);
      int insertIndex = targetIndex;
      if (insertIndex > fromIndex) {
        insertIndex -= 1;
      }
      insertIndex = insertIndex.clamp(0, items.length);
      items.insert(insertIndex, item);
    });

    _notifyItemsChanged();
    return true;
  }

  void _clearDragFlags() {
    _isReordering = false;
    _activeDraggedItemIndex = null;
    _currentDropIndex = null;
    _dropZoneKeys.clear();
  }
}

class _ArrayReorderScrollController {
  const _ArrayReorderScrollController();

  bool shouldScroll({required GlobalKey headerKey}) {
    final BuildContext? headerContext = headerKey.currentContext;
    if (headerContext == null) {
      return false;
    }
    return !_isHeaderVisible(headerContext);
  }

  void ensureHeaderVisible({
    required GlobalKey headerKey,
    required bool Function() isMounted,
  }) {
    final BuildContext? headerContext = headerKey.currentContext;
    if (headerContext == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isMounted()) {
        return;
      }
      try {
        Scrollable.ensureVisible(
          headerContext,
          alignment: 0.0,
          duration: Duration.zero,
          alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
        );
      } catch (_) {}
    });
  }

  bool _isHeaderVisible(BuildContext context) {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null) {
      return false;
    }

    final ScrollableState scrollable = Scrollable.of(context);
    final ScrollPosition position = scrollable.position;
    if (!position.hasPixels) {
      return false;
    }

    final RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject);

    final RevealedOffset revealed = viewport.getOffsetToReveal(renderObject, 0.0);
    final double headerTop = revealed.offset;
    final double headerBottom = headerTop + renderObject.paintBounds.height;
    final double viewportTop = position.pixels;
    final double viewportBottom = viewportTop + position.viewportDimension;

    return headerBottom >= viewportTop && headerTop <= viewportBottom;
  }
}

bool _schemaRepresentsObject(JsonSchema schema) {
  if (_schemaTypeIsObject(schema)) {
    return true;
  }

  final List<JsonSchema> combinators = [];
  combinators.addAll(schema.anyOf);
  combinators.addAll(schema.oneOf);
  combinators.addAll(schema.allOf);

  for (final candidate in combinators) {
    if (_schemaTypeIsObject(candidate)) {
      return true;
    }
  }

  return false;
}

bool _schemaIsPrimitive(JsonSchema schema) {
  SchemaType? type;
  try {
    type = schema.type;
  } catch (_) {
    type = null;
  }

  if (type == null) {
    return false;
  }

  switch (type) {
    case SchemaType.boolean:
    case SchemaType.integer:
    case SchemaType.number:
    case SchemaType.string:
      return true;
    default:
      return false;
  }
}

bool _schemaTypeIsObject(JsonSchema schema) {
  SchemaType? type;
  try {
    type = schema.type;
  } catch (_) {
    type = null;
  }
  return type == SchemaType.object;
}

class _ArrayActionSlot extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String tooltip;
  final VoidCallback? onTap;

  const _ArrayActionSlot({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    final Widget iconWidget = Icon(
      icon,
      color: enabled ? iconColor : iconColor.withValues(alpha: 0.4),
    );

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onTapDown: (_) => FocusScope.of(context).unfocus(),
        child: Center(child: iconWidget),
      ),
    );
  }
}

String _getArrayItemLabelBase(
  FormFieldContext parentContext, {
  FormFieldContext? childContext,
}) {
  return childContext?.title ?? parentContext.jsonSchema.items?.title ?? parentContext.title ?? 'Item';
}
