# --- Builder Stage ---
FROM --platform=linux/amd64 debian:bookworm-slim

# ARG GIT_USERNAME
# ARG GIT_EMAIL

# --- Env ---
ENV FLUTTER_SDK_ROOT=/usr/lib/flutter
ENV FLUTTER_SDK_VERSION=3.38.3-stable

# Android SDK environment variables
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}
# NOTE: no emulator in PATH because we don't use AVD
ENV PATH="${PATH}:${FLUTTER_SDK_ROOT}/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools"

# Don't ask questions during apt operations
ENV DEBIAN_FRONTEND=noninteractive

# --- Packages ---
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    watchman wget unzip zip curl gnupg git-all xz-utils \
    libglu1-mesa openjdk-17-jdk ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# --- Google Chrome & ChromeDriver ---
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor --yes -o /etc/apt/keyrings/google-linux.gpg && \
    chmod 644 /etc/apt/keyrings/google-linux.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list >/dev/null && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    CHROME_VERSION=$(google-chrome --version | awk '{print $3}'); \
    CHROME_MAJOR=${CHROME_VERSION%%.*}; \
    DRIVER_VERSION=$(curl -fsSL https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_${CHROME_MAJOR}); \
    curl -fsSL https://storage.googleapis.com/chrome-for-testing-public/${DRIVER_VERSION}/linux64/chromedriver-linux64.zip -o /tmp/chromedriver.zip; \
    unzip -q /tmp/chromedriver.zip -d /tmp; \
    mv /tmp/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver; \
    chmod +x /usr/local/bin/chromedriver; \
    rm -rf /tmp/chromedriver.zip /tmp/chromedriver-linux64

ENV CHROME_EXECUTABLE=/usr/bin/google-chrome
ENV CHROMEDRIVER=/usr/local/bin/chromedriver

# Java
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Git config (ensure flutter repo is trusted when running as root during build)
RUN git config --global --add safe.directory /usr/lib/flutter

# --- Flutter SDK ---
RUN mkdir -p ${FLUTTER_SDK_ROOT} && \
    cd ${FLUTTER_SDK_ROOT} && \
    curl -OL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz && \
    tar -xf flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz -C /usr/lib/ && \
    rm -f flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz

# --- Android SDK (cmdline-tools) ---
RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip -q commandlinetools-linux-11076708_latest.zip && rm -f commandlinetools-linux-11076708_latest.zip && \
    mkdir -p cmdline-tools/latest && \
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true

# --- SDK components (NO emulator/system-image) ---
# We also install API 35 (Android 15) because your physical device runs on it.
RUN yes | sdkmanager --licenses && \
    sdkmanager \
    "platform-tools" \
    "cmdline-tools;latest" \
    "platforms;android-35" "build-tools;35.0.0" \
    "platforms;android-34" "build-tools;34.0.0"

# --- Flutter/Android licenses, disable analytics ---
RUN yes | flutter doctor --android-licenses && \
    flutter --disable-analytics

# Login shell bash
SHELL ["/bin/bash", "-c"]

# Optional: ensure that in login shell there's NO ADB_SERVER_SOCKET inheritance
# (important for wifi-only case)
RUN printf 'unset ADB_SERVER_SOCKET >/dev/null 2>&1 || true\n' > /etc/profile.d/10-adb-nosocket.sh

# Useful alias: quick ADB (wifi-only local server)
RUN printf 'alias adb-local=\"unset ADB_SERVER_SOCKET; adb\" \n' > /etc/profile.d/11-adb-alias.sh

# Working directory
WORKDIR /workspace
