{ buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "mcp-language-server";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "isaacphi";
    repo = "mcp-language-server";
    rev = "main";
    hash = "sha256-INyzT/8UyJfg1PW5+PqZkIy/MZrDYykql0rD2Sl97Gg=";
  };
  vendorHash = "sha256-5YUI1IujtJJBfxsT9KZVVFVib1cK/Alk73y5tqxi6pQ=";
  proxyVendor = true;
  subPackages = [ "." ];
}
