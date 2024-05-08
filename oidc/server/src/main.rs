pub mod demo;

use demo::{
    demo_server::{Demo, DemoServer},
    DemoRequest, DemoResponse,
};
use tonic::{transport::Server, Request, Response, Status};

#[derive(Debug, Default)]
pub struct DemoImpl {}

#[tonic::async_trait]
impl Demo for DemoImpl {
    async fn without_authentication(
        &self,
        _request: Request<DemoRequest>,
    ) -> Result<Response<DemoResponse>, Status> {
        let response = DemoResponse {
            result: String::from("without authentication"),
        };
        Ok(Response::new(response))
    }

    async fn with_authentication(
        &self,
        _request: Request<DemoRequest>,
    ) -> Result<Response<DemoResponse>, Status> {
        let response = DemoResponse {
            result: String::from("with authentication"),
        };
        Ok(Response::new(response))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::1]:50051".parse()?;
    let demo_impl = DemoImpl::default();

    Server::builder()
        .add_service(DemoServer::new(demo_impl))
        .serve(addr)
        .await?;

    Ok(())
}
