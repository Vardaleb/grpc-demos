use std::sync::Arc;

use tonic::codegen::http::{HeaderValue, Request};
use tonic::{async_trait, Status};
use tonic_middleware::RequestInterceptor;

use super::auth_handler::AuthHandler;

#[derive(Clone)]
pub struct AuthInterceptor<A: AuthHandler> {
    pub auth_service: Arc<A>,
}

impl<A: AuthHandler> AuthInterceptor<A> {
    pub fn add_user_metadata(&self, user: &str, req: &mut Request<tonic::transport::Body>) {
        if let Ok(uid) = HeaderValue::from_str(&user.to_string()) {
            req.headers_mut().insert("user_id", uid);
        }
    }
}

#[async_trait]
impl<A: AuthHandler> RequestInterceptor for AuthInterceptor<A> {
    async fn intercept(
        &self,
        mut req: Request<tonic::transport::Body>,
    ) -> Result<Request<tonic::transport::Body>, Status> {
        // read the "authorization" header value
        if let Some(authorization_header) = req.headers().get("authorization") {
            let auth_header_value = authorization_header
                .to_str()
                .map_err(|e| Status::unauthenticated(e.to_string()))?;

            let mut parts = auth_header_value.splitn(2, ' ');
            let (scheme, params) = match (parts.next(), parts.next()) {
                (Some(scheme), Some(params)) => (scheme, params),
                (Some(_), None) => {
                    return Err(Status::unauthenticated(
                        "'Authorization' missing parameters",
                    ))
                }
                (None, _) => return Err(Status::unauthenticated("'Authorization' missing scheme")),
            };

            println!("Scheme: {}", scheme);
            println!("Params: {}", params);

            match self.auth_service.handle(scheme, params).await {
                Ok(user) => {
                    self.add_user_metadata(&user, &mut req);
                    return Ok(req);
                }
                Err(e) => {
                    return Err(Status::unauthenticated(format!(
                        "'{scheme}' Authentication failed: {}",
                        e
                    )))
                }
            }
        } else {
            return Err(Status::unauthenticated("'Authorization' header missing"));
        }
    }
}
