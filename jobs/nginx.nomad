job "nginx" {
  datacenters = ["zen"]

  group "nginx" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        static = 80
        to     = 80
        host_network = "public"
      }
      port "https" {
        static = 443
        to     = 443
        host_network = "public"
      }
    }

    service {
      name = "nginx"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "saffron"
              local_bind_port = 29001
            }
          }
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

    task "nginx" {
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
server {
	listen 80;
	listen [::]:80;
	return 301 https://$host$request_uri;
}

# sunsetglow.net - root page
server {
	listen 443 ssl;
	listen [::]:443 ssl;
	include snippets/ssl-sunsetglow.net.conf;
	include snippets/ssl-params.conf;
	server_name sunsetglow.net;
	root /www/index;
	index index.html;
}

# u.sunsetglow.net - image host
server {
	listen 443 ssl;
	listen [::]:443 ssl;
	include snippets/ssl-params.conf;
	include snippets/ssl-sunsetglow.net.conf;
	include snippets/proxy-params.conf;
	server_name u.sunsetglow.net;

  client_max_body_size 0;
  underscores_in_headers on;

  location ~ {
    add_header Front-End-Https on;
    proxy_pass http://{{ env "NOMAD_UPSTREAM_ADDR_saffron" }};
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
add_header Referrer-Policy "no-referrer";
EOF
        destination   = "local/snippets/ssl-params.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      template {
        data          = <<EOF
ssl_certificate /certs/live/sunsetglow.net/fullchain.pem;
ssl_certificate_key /certs/live/sunsetglow.net/privkey.pem;
EOF
        destination   = "local/snippets/ssl-sunsetglow.net.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
      template {
        data          = <<EOF
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
}
