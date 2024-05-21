use std::sync::Arc;

use jsonwebtoken::{decode, DecodingKey, Validation};
use openid::{Bearer, DiscoveredClient};
use serde::{Deserialize, Serialize};

const CLIENT_ID: &str = "demo";
const CLIENT_SECRET: &str = "8k6IZcpIszc4He4Sm8rDGGsNccKGFUlr";
const PROVIDER_URL: &str = "http://localhost:8080/realms/DEMO";

#[derive(Debug, Serialize, Deserialize)]
struct Claims {
    exp: usize,
    iat: usize,
    aud: String,
    iss: String,
    sub: String,
    preferred_username: String,
}

mod keycloak {
    use reqwest::Client;
    use serde::Deserialize;

    #[derive(Deserialize, Debug)]
    struct OpenIdConfiguration {
        jwks_uri: String,
    }

    #[derive(Deserialize, Debug)]
    struct JwksResponse {
        keys: Vec<JwkKey>,
    }

    #[derive(Deserialize, Debug)]
    struct JwkKey {
        kid: String,
        kty: String,
        alg: String,
        #[serde(rename = "use")]
        key_use: String,
        n: String,
        e: String,
    }

    pub async fn get_keycloak_public_key(
        keycloak_url: &str,
    ) -> Result<String, Box<dyn std::error::Error>> {
        let client = Client::new();

        // Retrieve the OpenID Configuration
        let oidc_config_url = format!("{}/.well-known/openid-configuration", keycloak_url);

        if let Ok(response) = client.get(&oidc_config_url).send().await {
            if !response.status().is_success() {
                let body = response.text().await?;
                println!("Error retrieving OpenID Configuration: {}", body);
                return Err("Failed to retrieve OpenID Configuration".into());
            }
            let oidc_config: OpenIdConfiguration = response.json().await?;

            // Retrieve the JWKS URI from the OpenID Configuration
            let jwks_url = oidc_config.jwks_uri;

            // Fetch the JWKS response from the JWKS URI
            match client.get(&jwks_url).send().await {
                Ok(response) => {
                    let jwks_response: JwksResponse = response.json().await?;

                    // Find the RSA public key from the JWKS response
                    let rsa_public_key = jwks_response
                        .keys
                        .iter()
                        .find(|key| key.kty == "RSA" && key.key_use == "sig")
                        .ok_or("No RSA public key found in JWKS")?;

                    // Construct the PEM-encoded public key
                    let public_key = base64_to_pem(&rsa_public_key.n, &rsa_public_key.e);
                    return Ok(public_key);
                }
                Err(e) => eprintln!("{}", e),
            }

            return Err("Failed to retrieve public key".into());
        } else {
            return Err("Failed to retrieve OpenID Configuration".into());
        }
    }

    fn base64_to_pem(base64_n: &str, base64_e: &str) -> String {
        let mut pem = String::new();
        pem.push_str("-----BEGIN PUBLIC KEY-----\n");

        let mut line_count = 0;
        let mut buf = vec![];

        for chunk in base64_n.as_bytes().chunks(64) {
            buf.extend_from_slice(chunk);
            buf.push(b'\n');
            line_count += 1;

            if line_count == 4 {
                pem.push_str(&String::from_utf8_lossy(&buf));
                buf.clear();
                line_count = 0;
            }
        }

        pem.push_str("-----END PUBLIC KEY-----\n");
        pem.push_str(&format!("e={}", base64_e));

        pem
    }
}

pub async fn handle(token: &str) -> Result<String, String> {
    let validation = Validation::new(jsonwebtoken::Algorithm::RS256);
    match keycloak::get_keycloak_public_key(PROVIDER_URL).await {
        Ok(public_key) => {
            println!("{}", public_key);
            let decoding_key = DecodingKey::from_rsa_pem(public_key.as_bytes())
                .map_err(|err| format!("Invalid public key: {}", err))?;

            match decode::<Claims>(&token, &decoding_key, &validation) {
                Ok(token_data) => {
                    let claims = token_data.claims;
                    println!("Token exp: {}", claims.exp);
                    println!("Token preferred_username: {}", claims.preferred_username);

                    // You can perform additional checks here, e.g., check if the token is expired
                    return Ok(claims.preferred_username.to_string());
                }
                Err(err) => return Err(format!("Invalid auth token: {}", err)),
            }
        }
        Err(e) => return Err(format!("{}", e)),
    }

    // Err("not implemented".to_string())
}

async fn _openid_test(token: &str) {
    let redirect = Some(String::from("http://localhost/login/oauth2/code/oidc"));
    let issuer = reqwest::Url::parse(PROVIDER_URL);
    let client = Arc::new(
        DiscoveredClient::discover(
            String::from(CLIENT_ID),
            Some(String::from(CLIENT_SECRET)),
            redirect,
            issuer.unwrap(),
        )
        .await
        .unwrap(),
    );
    println!("discover: {:#?}", client.config());

    let bearer: Bearer = serde_json::from_str(&format!(
        "{{\"token_type\":\"Bearer\", \"access_token\":\"{}\"}}",
        token
    ))
    .unwrap();

    println!("Bearer: {:?}", bearer);
}
