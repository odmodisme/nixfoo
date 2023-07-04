# WHOA! Even browsers with extensions can be declarative!
{ config, lib, pkgs, ... }:

{
  programs.brave = {
    enable = true;
    extensions = [
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      { id = "ekhagklcjbdpajgpjgmbionohlpdbjgc"; } # Zotero connector
      { id = "jfnifeihccihocjbfcfhicmmgpjicaec"; } # GSConnect
      { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } # Google Translate
      { id = "egpjdkipkomnmjhjmdamaniclmdlobbo"; } # Firenvim
      { id = "gknkbkaapnhpmkcgkmdekdffgcddoiel"; } # Open Access Button
      { id = "fpnmgdkabkmnadcjpehmlllkndpkmiak"; } # Wayback Machine
      { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell integration
      { id = "haebnnbpedcbhciplfhjjkbafijpncjl"; } # TinEye Reverse Image Search
      { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # Tampermonkey
      { id = "kkmlkkjojmombglmlpbpapmhcaljjkde"; } # Zhongwen
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "oldceeleldhonbafppcapldpdifcinji"; } # LanguageTool checker
    ];
  };

  programs.firefox = {
    enable = true;
    profiles.personal = {
      isDefault = true;
      settings = {
        "browser.search.widget.inNavBar" = true;
        "browser.search.openintab" = true;

        # Some privacy settings...
        "privacy.donottrackheader.enabled" = true;

        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.pbmode" = true;

        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;

        "dom.security.https_first" = true;
        "dom.security.https_first_pbm" = true;

        "privacy.firstparty.isolate" = true;
      };

      search = {
        default = "Brave";
        force = true;
        order = [
          "Brave"
          "Nix Packages"
          "Google"
        ];
        engines = {
          "Brave" = {
            urls = [{
              template = "https://search.brave.com/search";
              params = [
                { name = "type"; value = "search"; }
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${config.programs.brave.package}/share/icons/hicolor/64x64/apps/brave-browser.png";
            definedAliases = [ "@brave" "@b" ];
          };

          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g";
        };
      };
    };
  };
}