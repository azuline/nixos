job "ingress" {
  datacenters = ["frieren"]
  type        = "service"
  group "ingress" {
    count = 1
    network {
      mode = "bridge"
      port "http" {
        static       = 80
        to           = 80
        host_network = "public"
      }
      port "https" {
        static       = 443
        to           = 443
        host_network = "public"
      }
    }
    service {
      name = "ingress"
      port = "https"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "router"
              local_bind_port  = 19001
            }
          }
        }
      }
      check {
        name            = "root check"
        type            = "http"
        protocol        = "https"
        port            = "https"
        path            = "/"
        tls_skip_verify = true
        interval        = "10s"
        timeout         = "2s"
        header {
          Host       = ["sunsetglow.net"]
          User-Agent = ["Consul Healthcheck"]
        }
      }
    }
    task "ingress" {
      driver = "docker"
      config {
        image = "nginx"
        volumes = [
          "local/snippets:/etc/nginx/snippets",
          "local/nginx.conf:/etc/nginx/nginx.conf",
        ]
      }
      template {
        data          = <<EOF
user nginx;        
worker_processes auto;
error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
  log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                   '$status $body_bytes_sent "$http_referer" '
                   '"$http_user_agent" "$http_x_forwarded_for"';
  access_log /var/log/nginx/access.log main;
  server {
    listen 80;
    listen [::]:80;
    return 301 https://$host$request_uri;
  }
}
stream {
  log_format main '$remote_addr [$time_local] '
                  '$protocol $status $bytes_sent $bytes_received '
                  '$session_time';
  access_log /var/log/nginx/access.log main;
  server {
    listen 443;
    listen [::]:443;
    proxy_pass {{ env "NOMAD_UPSTREAM_ADDR_router" }};
  }
}
EOF
        destination   = "local/nginx.conf"
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
}
