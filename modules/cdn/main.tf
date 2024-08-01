resource "aws_cloudfront_distribution" "medialive" {

  enabled         = true
  comment         = "Created for Camera_1"
  http_version    = "http2"
  is_ipv6_enabled = true

  origin {
    domain_name = var.mediapackage_endpoint_url
    origin_id   = var.channel_id_media_package_camera_1
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "match-viewer"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_read_timeout      = 30
      origin_keepalive_timeout = 5
    }
    custom_header {
      name  = "X-MediaPackage-CDNIdentifier"
      value = var.mediapackage_uuid_secret
    }
  }
