import 'package:googleapis_auth/auth_io.dart';

class GetServerKeySevice {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "instagram-a799a",
        "private_key_id": "ba48d3111d6325aac7a66bde5398f7c7f5171c3e",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCrHBBT9A7t5hbh\n3Uc9EI/jYBXWkAed8gFbyMJ9bJwMMjdN0Qet+zB8C38CxsXyotMjPkXpUr5d5c3A\n3JcEKc4W96879g2NusN0KNn8QUm+KVHaCQzJCwAF3FDNIPfhri9hKyupqxY8P1pN\nYAUA1nEYQHjotyFxOIKVmHOSbMsBkHHzZRBOydzkolY09vmsSnaXYvESOygzscJ3\nwkuxCf2HU7IpZsAMbm0dOJCIm65dI2mSkgsglVwfmCKLtlLvWHGtHGNKlOfuMajE\nTj1jU2CmRVA6J5/brJbg7gSgXKybqg3CNDUf0q7rPI4r0NxPLwqVdrQWHwBdvD8h\noef9aif7AgMBAAECggEAKrJ2ipR4kzmalSLTz3OODCViXaeUFwAYAbC/g2+yIsL3\nFOZnnaz0BMgTmfxC0dB6ki1MYbQBh8m7xXfmASZzZDzLD9HOwQKNGjPFbVJXVenW\noGsosxQZHd1DlmQ3JqwB66PLoetswXznii4/IV3hW7Ve1mc4I5n/z9d6Y1vdblaV\nziKMVdnu5lt8QQk9fjwV1/4DoceRBxqLiT/Q4oE3UcUpBgA1wubOVEJMM7gObsS1\ngVhPYFrW2MYIFX+/gPhY6jaTu2MGbwA5Z2LD/KvtCFV82YL7L53vv6Q2SnHXcics\nK2tl9MeUKlKv2gcV2U6mNSpMMe4whexI4KYqnGPuVQKBgQDeCzQ3fHWxdKIfWJk/\nA39U5yjpFk6skTpOkzV8+JSttuYN9v24jRLlmDXLQDIsKgbgO0eez3qeR5Al8nK0\nc+DhpWzU0yuMw0hHzXazMTr7yw0GH9HafNJCVrNoB9Ja3skWTjJkHMu9xTa4DFdt\nK9luO/G7aj9ec/bScP2tb3S3nwKBgQDFRtaJ5x8BGKkM4EWdDMh4GxmH/8GD7b0I\nfjCeQBOJ7CzyMO9kezlKR5D7Ngu45eEp852pGWlWflO5Qw00ihsicTfhpzMaB8P/\nh/gGL295igmFFHGj3H228M+n5Uxepw4Xqv2/kgDwghxQIsNAz6/BP9i3I7s2vj9z\npDgiAAeiJQKBgQCE7I4g3VgTmK/pNf/fkjdq20tJZjpI4lPWcBfoLWPMLp7AI2k2\nTvXODnW9rDuc5rfhCnvQnYJZOJwZq29xiaFJU9+39IawqMMfgOebVFBsJd0xGmFl\ne63fWsnh8DTEg3Q77yoJdpedjm84dOLtjv+GF0qaGHvBDojm6A9lAUENHwKBgH2C\nLvX3a/tHlC3T9ZYQTu5S13B138kulIh1uDrGK2ghMQs45OU5nF5Mn8mjPdv5rMIC\n8vhlaWYU4vFH3nvhrZfBDjtrI5DZBfJpr/tHbJWXo6zeL9p/ah/cn1CDCo5hnA6k\nw+GAY0agkKDPLQfr2jaJhzgk7HPMoBPTk77V5AVdAoGAZ8teby04gSBSVFYiCqGU\nvyH5OOIw657LLSl6mp3y+3eAG6z5xLHIaAXrf8fKH0zhrZCyrpxFLrA0T2KESIeA\nbxQxDPHZ13IkA4DY3hbTkMfvDeSBmGJ+Otjrrv8PHxXP5X6mx8SRZsPj933XXXXC\n4yixlsd9tMOYKuLCm99lu+8=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@instagram-a799a.iam.gserviceaccount.com",
        "client_id": "117098412410491565108",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40instagram-a799a.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    print('Token generated: ${accessServerKey.substring(0, 20)}...');
    print('Token expiry: ${client.credentials.accessToken.expiry}');
    return accessServerKey;
  }
}
