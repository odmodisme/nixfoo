# It just contains a set of network-related variables mainly used for
# network-related services. Make sure to change this every time you migrate to
# a new server.
let
  inherit (builtins) toString;
in
rec {
  publicIP = "95.217.212.19";
  publicIPPrefixLength = 32;
  publicIP' = "${publicIP}/${toString publicIPPrefixLength}";

  publicIPv6 = "2a01:4f9:c011:a448::";
  publicIPv6PrefixLength = 64;
  publicIPv6' = "${publicIPv6}/${toString publicIPv6PrefixLength}";

  # The private network for this host.
  privateIPNetworkRange = "172.16.0.0/32";
  privateNetworkGatewayIP = "172.16.0.1/32";
  privateNetworkServicesPart = "172.18.25";
  privateNetworkHostPart = hostPart: "${privateNetworkServicesPart}.${toString hostPart}";

  wireguardIPv6 = "fdee:b0de:54e6:ae74::";
  wireguardIPv6LengthPrefix = 64;
  wireguardPort = 51820;

  # Applications that are supposed to be internal.
  atuinHost = privateNetworkHostPart 3;
  keycloakHost = privateNetworkHostPart 4;
}
