vcl 4.0;
# Based on: https://github.com/mattiasgeniar/varnish-4.0-configuration-templates/blob/master/default.vcl

import std;
import directors;

backend bunny {
  .host = "bunny";
  .port = "5000";
}

backend galleryservice {
  .host = "galleryservice";
  .port = "5000"; 
}

/*
acl purge {
  # ACL we"ll use later to allow purges
  "localhost";
  "127.0.0.1";
  "::1";
}

acl editors {
  # ACL to honor the "Cache-Control: no-cache" header to force a refresh but only from selected IPs
  "localhost";
  "127.0.0.1";
  "::1";
}
*/

sub vcl_init {
  # Called when VCL is loaded, before any requests pass through it.
  # Typically used to initialize VMODs.

  new vdir = directors.round_robin();
  vdir.add_backend(galleryservice);
  # vdir.add_backend(server...);
  # vdir.add_backend(servern);
}

sub vcl_backend_response {
  set beresp.do_esi = true;
  unset beresp.http.set-cookie;

  set beresp.http.Vary = "Accept-Language, Accept-Version";
}

sub vcl_deliver {
  unset resp.http.Via;
  unset resp.http.Cache-Control;
  unset resp.http.X-Powered-By;
  unset resp.http.Vary;
  unset resp.http.X-Varnish;
  unset resp.http.Age;
  unset resp.http.Server;
  set resp.http.Cache-Control = "private, max-age=0, no-cache";
  set resp.http.Server = "cloudflare-nginx";
  set resp.http.X-Powered-By = "Phusion Passenger (mod_rails/mod_rack) 3.0.17";
}

sub vcl_recv {
  // Normalise incoming requests
  unset req.http.Vary;
  unset req.http.Cache-Control;
  unset req.http.Host;
  unset req.http.Upgrade-Insecure-Requests;
  unset req.http.User-Agent;
  unset req.http.Authorization;
  unset req.http.Accept;
  unset req.http.Accept-Encoding;
  set req.http.Accept = "*/*";
  set req.http.Accept-Encoding = "gzip";

  // Supported languages en, tr, ru, pt
  if (req.http.Accept-Language) {
    if (req.http.Accept-Language ~ "en") {
      set req.http.Accept-Language = "en";
    } else {
      unset req.http.Accept-Language;
    }
  }

  // Backend to hit
  if (req.url ~ "^/images") {
    set req.backend_hint = galleryservice;
  } else {
    set req.backend_hint = bunny;
  }
}
