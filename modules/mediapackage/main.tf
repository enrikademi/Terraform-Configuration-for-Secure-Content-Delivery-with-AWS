resource "aws_media_package_channel" "media_package_camera_1" {
  depends_on  = [aws_medialive_input.live_input_camera_1]
  channel_id  = "${var.environment}-media_package_camera_1"
  description = "A channel dedicated for camera 1 videos"
}

resource "random_uuid" "mediapackage_uuid" {}

resource "null_resource" "mediapackage_origin_endpoint" {
  depends_on = [aws_media_package_channel.media_package_camera_1, aws_secretsmanager_secret_version.mediapackage_uuid_secret_version, aws_secretsmanager_secret.mediapackage_uuid_secretsmanager]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      # echo "Starting script to create MediaPackage Origin Endpoint"
      # Retrieve MediaPackageCDNIdentifier from Secrets Manager

      # Create MediaPackage Origin Endpoint
      ORIGIN_ENDPOINT_ID="mediapackage1"

      aws mediapackage create-origin-endpoint \
        --id "$ORIGIN_ENDPOINT_ID" \
        --channel-id "${aws_media_package_channel.media_package_camera_1.id}" \
        --manifest-name "index" \
        --startover-window-seconds 86400 \
        --time-delay-seconds 0 \
        --hls-package 'SegmentDurationSeconds=6,PlaylistType=EVENT,PlaylistWindowSeconds=60,AdMarkers=NONE' \
        --authorization '{ "CdnIdentifierSecret": "${aws_secretsmanager_secret.mediapackage_uuid_secretsmanager.arn}", "SecretsRoleArn": "${var.mediapackage_role_arn}" }'
      
      ENDPOINT_URL=$(aws mediapackage describe-origin-endpoint --id "$ORIGIN_ENDPOINT_ID" | jq -r '.Url | sub("https://"; "") | split("/")[0]')
      echo "Retrieved Endpoint Details: $ENDPOINT_URL"

      MediaPackage_URL=$(aws mediapackage describe-origin-endpoint --id "$ORIGIN_ENDPOINT_ID" | jq -r '.Url' | sed -e 's|https://[^/]*||')
      echo "Retrieved Endpoint Details: $MediaPackage_URL"
      
      joined_url="https://${var.cloudfront_domain_name}$MediaPackage_URL"

      # echo "Storing CDN URL url in SSM Parameter Store"
     aws ssm put-parameter --name "/${var.project_name}/${var.environment}/main-stream-stereo-audio/cdn/endpoint/url" --type "String" --value "$joined_url" --overwrite

      # echo "Storing Origin Endpoint url in SSM Parameter Store"
      aws ssm put-parameter --name "/${var.project_name}/${var.environment}/mediapackage/endpoint-url" --type "String" --value "$ENDPOINT_URL" --overwrite
    EOT
  }

}
