use chrono::prelude::*;
use jsonwebtoken::{decode, Algorithm, DecodingKey, Validation};
use serde::{Deserialize, Serialize};

const CLIENT_ID: &str = "demo";
const CLIENT_SECRET: &str = "8k6IZcpIszc4He4Sm8rDGGsNccKGFUlr";

#[derive(Debug, Serialize, Deserialize)]
struct Claims {
    exp: usize,
    iat: usize,
    aud: String,
    iss: String,
    sub: String,
    preferred_username: String,
}

pub async fn handle(token: &str) -> Result<String, String> {
    println!("Token: {}", token);

    // No secret provided, so signature validation is skipped (not recommended for production)
    let validation = &mut Validation::new(Algorithm::RS256);
    validation.insecure_disable_signature_validation();
    validation.set_audience(&["account"]);

    match decode::<Claims>(token, &DecodingKey::from_secret(&[]), &validation) {
        Ok(decoded_token) => {
            println!("Decoded Claims: {:?}", decoded_token.claims);

            // Convert timestamps to human-readable format
            let exp_time = Utc
                .timestamp_opt(decoded_token.claims.exp as i64, 0)
                .single()
                .unwrap_or_default();
            let iat_time = Utc
                .timestamp_opt(decoded_token.claims.iat as i64, 0)
                .single()
                .unwrap_or_default();

            // Display claims with human-readable timestamps
            println!("Expiration Time (UTC): {}", exp_time);
            println!("Issued At (UTC): {}", iat_time);
            println!("Expiration Time (local): {}", exp_time.with_timezone(&Local));
            println!("Issued At (local): {}", iat_time.with_timezone(&Local));
        }
        Err(e) => println!("Error: {:#?}", e),
    }

    // openidconnect().await;

    Err("not implemented".to_string())
}

// use openidconnect::{
//     core::{CoreClient, CoreProviderMetadata},
//     reqwest::async_http_client,
//     ClientId, ClientSecret, IssuerUrl,
// };

// async fn openidconnect() {
//     let provider_url = String::from("http://localhost:8080/realms/DEMO");
//     if let Ok(issuer_url) = &IssuerUrl::new(provider_url) {
//         match CoreProviderMetadata::discover_async(issuer_url.clone(), async_http_client).await {
//             Ok(provider_meta_data) => {
//                 println!("Provider-Metadata: {:#?}", provider_meta_data);
//                 let client = CoreClient::from_provider_metadata(
//                     provider_meta_data,
//                     ClientId::new(CLIENT_ID.to_string()),
//                     Some(ClientSecret::new(CLIENT_SECRET.to_string())),
//                 );

//                 // TODO: continue research...
//             }
//             Err(e) => println!("Error: {:?}", e),
//         }
//     }
// }

mod tests {

    #[test]
    fn test_chrono() {
        let utc = chrono::Utc::now();
        let local = chrono::Local::now();
        let converted: chrono::DateTime<chrono::Local> = chrono::DateTime::from(utc);
        println!("{:?}", utc);
        println!("{:?}", local);
        println!("{:?}", converted);
    }
}
