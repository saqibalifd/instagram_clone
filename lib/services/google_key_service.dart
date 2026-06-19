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
        "private_key_id": "b4397d941a477b99e5fdeebd74b624c10cae0031",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDExUPMXLrDJtvi\ntYoe5KLn5KvgKlsV/9npPHkWOwwsb68B5x+vpVXf1+cvQMr7DeW0/kDGGMfza6oE\nOPgYvQnqZTlZMHbSQ0OT2I0/Udao/XGHN5oZFhdcxNOqGroU2vQA7SH9KwKydLpb\n0tDCsMs3nkrl2ND23wBil1ICWBjGaXZ/CeMApJG9P6akKQWulSCPrXRpyAaNkUgm\n9ICzF/q8+mu+L+5SsXWNMWHjScemXDhb5mCkZUbym8+vL6jxgTe2VluaieWNtULG\nLJZd8BS7rcVh95CuJ5zDWOeUTdyDunnxol3GhKoa9NCn/dyAv/b+5geprz5CQW/Y\nZGGsa8UzAgMBAAECggEAImgJ5FycjY4oabprpd49vAWopiBR4AVmUZmw5Jm7lbOL\nqu4ChOCIpQToGEOgmoiCD4VbxyfDIsXDK0zY2N6JMtKzVeybAkYftWTqwdUqD0+N\nv+KRj+xkdmS2TCqzOf1VKCpOxKl2JcUyZub0eO6YAigsGYexdlFlDFhAT0efQWYV\n8XIu4OfRqw5g045Eu3vaCFeHFE2Cn+RUk5sTYyVxc0qtggJuMXmu52aOFRw+7Yjl\nwEEe+sGWNhieI7zGRvRTGzMfDNouNPJyFGvukiXkxm38Ht8iwxme4PNvW9s39Ktl\nzNfGxVzwKbTyJUPIH9+tMXcR4QSl16qHlf6JRSAQCQKBgQDqW5OVzi1Q9Rsu7Cw5\nOw5ERDGxQsOABK8zQem04QINJl5AEbawb6H01WQxzNcFxTOAnAqlN6LkxFA3w2Fa\n+VEbRQK62SFWFqR7ptgfLKOXHrmYMmHxKca1ussPmwidRFDZpi7J7tW3nIBD80NG\ntWaHuDrg42XdjgNNhW2709A32QKBgQDW8RhEZLP7QLU7AzECyV1XlRz9Eku2TIAX\nBLR/qQHMSTY6g6CLLDbStqEt5+hc7pmmIZ54zMXvrOiRciWKR/ipuoRg4EyDBOVZ\nYeESI0rtumFe/r6XQeMyxido8I5sp8ON/kceiNHz5esevB/25p6Eqbo2OGsz83Gz\nBErC8JTp6wKBgQCNFurIEmMnzRg7bIXHQq15HdEI1ZfbF3belfz8H0Zb4lB1o/Rn\nTh2jx2BVtutwluNFtyuVgeQ4c5OTrrWKznQsxaQ6FwRBzsnhg3Wzdu1Zym6TmSlr\nxenSeI1NbNmHzJwcHDco7PePXdG+ltJW3FjItnoD8ALgmmGUpxKENKWzKQKBgCw6\nDaE9C1+ej+vlmzcUkfVMhFt6YUPQd+bEnBNMhkcvpU3i+azJWzp+Q6n7du9wVQM/\nFamLkQrhDDWpRBow9vSNoWGBpZyr7Dk5D6O4yVkjKZfvWO4sq4AuD7vjC5tF5dIY\nyS96PaEu5PM9CGK4T1PCzMMNVtmotPN95Zg5ApsjAoGBAKE0yqVwNkWmG2K5cTql\ngAF3OtbcLwVi5KZXG9hn/P3TscJvs7CZ3IJfvMpgrUUQ8z9ShnQtTvCIKvI5BF1F\nbVN2uIVeKVaPmN3WXH1EaijG7/DWvZhqtjx+sFrglHrIKqIrrPR01+hDNZPiM7di\nVFQE9Fx3jcxMTKBOHzdDNdl0\n-----END PRIVATE KEY-----\n",
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
