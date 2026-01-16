/// Preset form data for example forms
library;

Map<String, dynamic> getFormDataReisekostenantrag() {
  return {
    "fs_sonstige_kosten": "Hallo",
    "fg_bankverbindung_fs_kontoauswahl": "Auf das Ihnen bereits bekannte Konto",
    "fg_art_der_fahrt": [
      {
        "fg_art_der_fahrt_fs_art_der_fahrt": "Fahrten zu einer ärztlichen Begutachtung/ Zusatzbegutachtung",
        "fg_art_der_fahrt_fs_ziel": "1234",
        "fg_art_der_fahrt_fs_verkehrsmittel": "Taxi (ärztliche Bescheinigung über die Notwendigkeit erforderlich)",
        "fg_art_der_fahrt_fg_begleit_verdienstausf_fs_verdienstausfall": true,
        "fg_art_der_fahrt_fg_arr_datumsangaben": [
          {"fg_art_der_fahrt_fg_arr_datumsangaben_fs_datum": "2025-09-05T00:00:00.000"}
        ]
      },
      {
        "fg_art_der_fahrt_fs_art_der_fahrt": "Fahrten zum Arzt/ zur Ärztin oder zum Therapeuten/ zur Therapeutin",
        "fg_art_der_fahrt_fs_verkehrsmittel": "Kraftfahrzeug",
        "fg_art_der_fahrt_fg_begleit_verdienstausf_fs_verdienstausfall": false,
        "fg_art_der_fahrt_fg_arr_datumsangaben": [
          {"fg_art_der_fahrt_fg_arr_datumsangaben_fs_datum": "2025-09-15T00:00:00.000"}
        ],
        "fg_art_der_fahrt_fs_ziel": "1234"
      },
      {
        "fg_art_der_fahrt_fs_ziel": "test",
        "fg_art_der_fahrt_fg_begleit_verdienstausf_fs_verdienstausfall": false,
        "fg_art_der_fahrt_fg_arr_datumsangaben": [
          {"fg_art_der_fahrt_fg_arr_datumsangaben_fs_datum": "2025-09-03T00:00:00.000"}
        ]
      }
    ]
  };
}

Map<String, dynamic> getFormDataFiverules() {
  return {
    "arbeitsstelle-arbeitsort": "we",
    "person-in-der-rolle-des-anlagenverantwortlichen": "qe",
    "person-in-der-rolle-des-arbeitsverantwortlichen": "we",
    "arbeitsausfuhrende-person": "we",
    "zusatzliche-personliche-schutzausrustung": "gegen elektrischen Schlag",
    "stehen-andere-anlagenteile-weiterhin-unter": "nein",
    "edi43ba285a6396493da82241d5ecec090d": "NH-Sicherungen",
    "edi812abac1f12d44d18d4415cb1ddb1984": "12",
    "edi7bd23a69de5141aaa4379b4ba2b979ba": "Trafostation",
    "edi3dc9a71b7dc547d6a55d036bd2417578": "qw",
    "edic589597967b44e00af9e74c7c1319cb0": "ja",
    "edi64719875ff504d6eb8fd735f12fd7d17": "ja",
    "edi6af7fbabb2a44046b882d580080326e1": "angehängt",
    "edi5ce0ca9d1def423c8670f650f8d6c60f": "ja",
    "edi594b8869f8884cb4b76d376d960c3b74": "qw",
    "ediec7dc4dfa3b646818f003c01c9f1709c": "in die NH-Sicherungsunterteile",
    "edi8eb283983de7413b9b8b9530fb227543": "teilweiser Berührungsschutz",
    "edid11961ed04714161961a663f2e9cae09": "isolierende Formteile"
  };
}

Map<String, dynamic> getFormDataGfk1() {
  return {
    "edi8b505fbc30dc4886ac64c349ac69e6bd": "eine externe Betreuung",
    "edi9f7346b16e2f4b458c0ed18bea737293": {
      "edi5c58446c8aad47d5afde2baae293ad2c": "Maßnahme durchgeführt",
      "edi87b00b6afd0645b8933a898d34b9af9b": {"edi87b00b6afd0645b8933a898d34b9af9b_ref1": true},
      "edi388a83c4b652492590445f30283d1780": "Maßnahme veranlasst"
    },
    "edi53eeed3e5bfe4535875b0e726286ada0": "Maßnahme durchgeführt",
    "edi1ceb1850266e4b24a027cb041363b3fd": {"edi1ceb1850266e4b24a027cb041363b3fd_ref1": true},
    "edif75daee98a2a441fab451a57fd3f9d8a": "Maßnahme veranlasst",
    "edi9d17a5183df84951a6299a99fdc5e9d3": "Maßnahme veranlasst",
    "edia2d018bbe168436bb8a1aa3bc3c4ad03": "Maßnahme veranlasst",
    "edi200f233ff7014bcf8402e2da79092955": "Maßnahme veranlasst",
    "edia19fd4a2e3bb4783b79d323d2bde86d0": "Maßnahme veranlasst",
    "edi98ff05f6adf04f38938784827156734b": "Maßnahme veranlasst",
    "ediadc30e5a7357430a978a9787c565edb9": "Maßnahme veranlasst",
    "edi939e8b8bf478458296adce761b606406": "Maßnahme veranlasst",
    "edi2602f7372a9a4b889df830f127eef94f": "Maßnahme veranlasst",
    "edib16799233e0d44be8a25346a28faba9d": "Maßnahme veranlasst",
    "edi05ed54521489439dbc8af11cf7922460": "Maßnahme veranlasst",
    "edi983e099be3d4490aaee11c843e414dbd": "Maßnahme veranlasst",
    "edi2e1a24d9190b4b6c90d0730d477c34b5": "Maßnahme veranlasst"
  };
}

Map<String, dynamic> getFormDataShowcase() {
  return {
    "name": "John Doe",
    "title": "Mr.",
    "group_selector": "Object",
    "testArray": [
      "Test 1",
      "Test 2",
    ],
    "testObject": {
      "petName": "1",
      "age": "2",
      "flauschig": true,
    },
  };
}

Map<String, dynamic> getOther() {
  return {
    "edi8b505fbc30dc4886ac64c349ac69e6bd": "eine externe Betreuung",
    "edi53eeed3e5bfe4535875b0e726286ada0": "Maßnahme durchgeführt",
    "edif75daee98a2a441fab451a57fd3f9d8a": "Maßnahme veranlasst",
    "edi9d17a5183df84951a6299a99fdc5e9d3": "Maßnahme veranlasst",
    "edia2d018bbe168436bb8a1aa3bc3c4ad03": "Maßnahme veranlasst",
    "edi200f233ff7014bcf8402e2da79092955": "Maßnahme veranlasst",
    "edia19fd4a2e3bb4783b79d323d2bde86d0": "Maßnahme veranlasst",
    "edi98ff05f6adf04f38938784827156734b": "Maßnahme veranlasst",
    "ediadc30e5a7357430a978a9787c565edb9": "Maßnahme veranlasst",
    "edi939e8b8bf478458296adce761b606406": "Maßnahme veranlasst",
    "edi2602f7372a9a4b889df830f127eef94f": "Maßnahme veranlasst",
    "edib16799233e0d44be8a25346a28faba9d": "Maßnahme veranlasst",
    "edi05ed54521489439dbc8af11cf7922460": "Maßnahme veranlasst",
    "edi983e099be3d4490aaee11c843e414dbd": "Maßnahme veranlasst",
    "edi2e1a24d9190b4b6c90d0730d477c34b5": "Maßnahme veranlasst",
    "edi9f7346b16e2f4b458c0ed18bea737293": {
      "edi5c58446c8aad47d5afde2baae293ad2c": "Maßnahme durchgeführt",
      "edi388a83c4b652492590445f30283d1780": "Maßnahme veranlasst",
      "edi87b00b6afd0645b8933a898d34b9af9b": {"edi87b00b6afd0645b8933a898d34b9af9b_ref1": false}
    },
    "edi1ceb1850266e4b24a027cb041363b3fd": {"edi1ceb1850266e4b24a027cb041363b3fd_ref0": "Test", "edi1ceb1850266e4b24a027cb041363b3fd_ref1": true}
  };
}

Map<String, dynamic> getRegistration() {
  return {
    "firstName": "John",
  };
}
