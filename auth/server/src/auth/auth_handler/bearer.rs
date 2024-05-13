use openidconnect::{core::{CoreClient, CoreProviderMetadata}, reqwest::async_http_client, ClientId, ClientSecret, IssuerUrl};

const CLIENT_ID: &str = "demo";
const CLIENT_SECRET: &str = "8k6IZcpIszc4He4Sm8rDGGsNccKGFUlr";

pub async fn handle(token: &str) -> Result<String, String> {
    println!("Token: {}", token);
    let provider_url = String::from("http://localhost:8080/realms/DEMO");

    if let Ok(issuer_url) = &IssuerUrl::new(provider_url) {
        match CoreProviderMetadata::discover_async(issuer_url.clone(), async_http_client).await {
            Ok(provider_meta_data) => {
                println!("Provider-Metadata: {:#?}", provider_meta_data);
                let client =
                CoreClient::from_provider_metadata(
                    provider_meta_data,
                    ClientId::new(CLIENT_ID.to_string()),
                    Some(ClientSecret::new(CLIENT_SECRET.to_string())),
                );

                // TODO: continue research...
            }
            Err(e) => println!("Error: {:?}", e),
        }
    }

    Err("not implemented".to_string())
}
