job "router" {
  datacenters = ["frieren"]
  type        = "service"
  group "router" {
    count = 1
    network {
      mode = "bridge"
    }
    service {
      name = "router"
      port = "443"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "saffron"
              local_bind_port  = 29001
            }
            upstreams {
              destination_name = "blossom-ladle"
              local_bind_port  = 29002
            }
            upstreams {
              destination_name = "sunsetglow-site"
              local_bind_port  = 29003
            }
            upstreams {
              destination_name = "umami"
              local_bind_port  = 29004
            }
          }
        }
      }
      check {
        name            = "root check"
        type            = "http"
        protocol        = "https"
        address_mode    = "alloc"
        path            = "/"
        tls_skip_verify = true
        interval        = "10s"
        timeout         = "2s"
        header {
          Host       = ["sunsetglow.net"]
          User-Agent = ["Consul Healthcheck"]
        }
      }
      check {
        name            = "blossom check"
        type            = "http"
        protocol        = "https"
        address_mode    = "alloc"
        path            = "/"
        tls_skip_verify = true
        interval        = "10s"
        timeout         = "2s"
        header {
          Host       = ["celestial.sunsetglow.net"]
          User-Agent = ["Consul Healthcheck"]
        }
      }
      check {
        name            = "saffron check"
        type            = "http"
        protocol        = "https"
        address_mode    = "alloc"
        path            = "/login"
        tls_skip_verify = true
        interval        = "10s"
        timeout         = "2s"
        header {
          Host       = ["u.sunsetglow.net"]
          User-Agent = ["Consul Healthcheck"]
        }
      }
      check {
        name            = "umami check"
        type            = "http"
        protocol        = "https"
        address_mode    = "alloc"
        path            = "/api/heartbeat"
        tls_skip_verify = true
        interval        = "10s"
        timeout         = "2s"
        header {
          Host       = ["ozu.sunsetglow.net"]
          User-Agent = ["Consul Healthcheck"]
        }
      }
    }
    volume "certs" {
      type      = "host"
      source    = "sunsetglow-certs"
      read_only = true
    }
    volume "site" {
      type      = "host"
      source    = "sunsetglow-site"
      read_only = true
    }
    task "router" {
      driver = "docker"
      config {
        image = "nginx"
        volumes = [
          "local/snippets:/etc/nginx/snippets",
          "local/nginx.conf:/etc/nginx/conf.d/default.conf",
        ]
      }
      volume_mount {
        volume      = "certs"
        destination = "/certs"
      }
      volume_mount {
        volume      = "site"
        destination = "/www"
      }
      template {
        data          = <<EOF
# sunsetglow.net - root page
server {
  listen 443 ssl;
  listen [::]:443 ssl;
  http2 on;
  include snippets/ssl-params.conf;
  include snippets/ssl-sunsetglow.net.conf;
  server_name sunsetglow.net;
  location ~ {
    include snippets/proxy-params.conf;
    proxy_pass http://{{ env "NOMAD_UPSTREAM_ADDR_sunsetglow-site" }};
  }
}

# ozu.sunsetglow.net - umami
server {
  listen 443 ssl;
  listen [::]:443 ssl;
  http2 on;
  include snippets/ssl-params.conf;
  include snippets/ssl-sunsetglow.net.conf;
  server_name ozu.sunsetglow.net;
  location ~ {
    include snippets/proxy-params.conf;
    proxy_pass http://{{ env "NOMAD_UPSTREAM_ADDR_umami" }};
  }
}

# u.sunsetglow.net - image host
server {
  listen 443 ssl;
  listen [::]:443 ssl;
  http2 on;
  include snippets/ssl-params.conf;
  include snippets/ssl-sunsetglow.net.conf;
  server_name u.sunsetglow.net;
  client_max_body_size 0;
  underscores_in_headers on;
  location ~ {
    include snippets/proxy-params.conf;
    proxy_pass http://{{ env "NOMAD_UPSTREAM_ADDR_saffron" }};
  }
}

# celestial.sunsetglow.net - design system ladle
server {
  listen 443 ssl;
  listen [::]:443 ssl;
  http2 on;
  include snippets/ssl-params.conf;
  include snippets/ssl-sunsetglow.net.conf;
  server_name celestial.sunsetglow.net;
  location ~ {
    include snippets/proxy-params.conf;
    proxy_pass http://{{ env "NOMAD_UPSTREAM_ADDR_blossom-ladle" }};
  }
}

# f.sunsetglow.net - files
server {
  listen 443 ssl;
  listen [::]:443 ssl;
  http2 on;
  include snippets/ssl-sunsetglow.net.conf;
  include snippets/ssl-params.conf;
  server_name f.sunsetglow.net;
  root /www/index;
  index index.html;
  location /files/ {
    autoindex on;
  }
}
EOF
        destination   = "local/nginx.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      template {
        data          = <<EOF
# https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
ssl_prefer_server_ciphers on;
ssl_session_cache shared:SSL:10m;
ssl_ecdh_curve secp384r1;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
resolver 1.1.1.1 valid=300s;
resolver_timeout 5s;
add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
add_header X-Frame-Options sameorigin;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
EOF
        destination   = "local/snippets/ssl-params.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      template {
        data          = <<EOF
ssl_certificate /certs/sunsetglow.net/fullchain.pem;
ssl_certificate_key /certs/sunsetglow.net/key.pem;
EOF
        destination   = "local/snippets/ssl-sunsetglow.net.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      template {
        data          = <<EOF
proxy_http_version 1.1;
proxy_set_header Host $http_host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_headers_hash_max_size 512;
proxy_headers_hash_bucket_size 64;
proxy_buffering off;
proxy_redirect off;
proxy_max_temp_file_size 0;
EOF
        destination   = "local/snippets/proxy-params.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
    }
  }
  update {
    max_parallel      = 1
    health_check      = "checks"
    min_healthy_time  = "10s"
    healthy_deadline  = "1m"
    progress_deadline = "10m"
    auto_revert       = true
    auto_promote      = true
    canary            = 1
  }
}
