# Terraform Demo: Integrating AWS CloudFront, Elemental MediaPackage, and Secrets Manager for Secure Content Delivery

## This will enhances security by ensuring that only requests with valid and authorized identifiers can access and distribute media content.


```bash
Overview
The process involves the following steps:

AWS CloudFront serves as the entry point, distributing content to end-users with high availability and security.
AWS Elemental MediaPackage acts as the origin server, packaging content dynamically to optimize for different devices. It plays a crucial role in verifying that requests are authenticated using custom headers.
Custom HTTP Headers: These are utilized to carry authentication tokens or identifiers that are crucial for securing communication between CloudFront and MediaPackage.
AWS Secrets Manager: This service manages the secrets (like API keys or tokens) that are used in the custom HTTP headers. It ensures that sensitive information is stored securely and is accessible only through proper authentication mechanisms.
AWS IAM (Identity and Access Management): This controls the permissions and access policies that secure interactions between the different AWS services involved in the process.
How It Works
When a playback request is initiated by a user:

The request first hits AWS CloudFront, which then forwards it to AWS Elemental MediaPackage with a custom header containing a secret identifier.
Elemental MediaPackage consults AWS Secrets Manager to validate that the secret in the custom header matches a secure, stored value.
Once validated, MediaPackage processes the request, ensuring that only authenticated requests receive content, thus maintaining a high level of security.

```


## This is the process we'll achieve.
![cdn_auth](https://github.com/user-attachments/assets/5dedbe7f-6b0e-408e-b93f-ceed49996ac3)
