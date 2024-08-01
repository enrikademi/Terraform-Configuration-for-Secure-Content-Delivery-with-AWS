resource "aws_secretsmanager_secret" "mediapackage_uuid_secretsmanager" {
  depends_on = [ random_uuid.mediapackage_uuid ]
  name        = "MediaPackage-UUID-secret-manager"
  description = "Stores a UUID for CDN custom header"

  tags = {
    name        = "MediaPackage-UUID-secret-managerTerraform"
  }
}

resource "aws_secretsmanager_secret_version" "mediapackage_uuid_secret_version" {
  depends_on = [ random_uuid.mediapackage_uuid ]

  secret_id     = aws_secretsmanager_secret.mediapackage_uuid_secretsmanager.id
  secret_string = jsonencode({
    MediaPackageCDNIdentifier = random_uuid.mediapackage_uuid.id
  })
}
