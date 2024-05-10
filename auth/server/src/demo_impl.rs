use tonic::{Request, Response, Status};

use crate::demo::{
    demo_service_server::DemoService, no_auth_demo_service_server::NoAuthDemoService,
    WithAuthenticationRequest, WithAuthenticationResponse, WithoutAuthenticationRequest,
    WithoutAuthenticationResponse,
};

#[derive(Debug, Default)]
pub struct DemoImpl {}

#[tonic::async_trait]
impl DemoService for DemoImpl {
    async fn with_authentication(
        &self,
        request: Request<WithAuthenticationRequest>,
    ) -> Result<Response<WithAuthenticationResponse>, Status> {
        println!("{:?}", request.metadata().get("user_id"));
        let response = WithAuthenticationResponse {
            result: String::from("with authentication"),
        };
        Ok(Response::new(response))
    }
}

#[derive(Debug, Default)]
pub struct NoAuthDemoImpl {}

#[tonic::async_trait]
impl NoAuthDemoService for NoAuthDemoImpl {
    async fn without_authentication(
        &self,
        _request: Request<WithoutAuthenticationRequest>,
    ) -> Result<Response<WithoutAuthenticationResponse>, Status> {
        let response = WithoutAuthenticationResponse {
            result: String::from("without authentication"),
        };
        Ok(Response::new(response))
    }
}
