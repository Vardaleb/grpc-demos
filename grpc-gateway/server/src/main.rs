use hello::{
    greeter_server::{Greeter, GreeterServer},
    Greeting,
};
use tonic::{transport::Server, Request, Response, Status};

pub mod hello;

#[derive(Debug, Default)]
pub struct GreeterImpl {}

#[tonic::async_trait]
impl Greeter for GreeterImpl {
    async fn greet(&self, request: Request<Greeting>) -> Result<Response<Greeting>, Status> {
        let message = request.into_inner().message;
        let reply = hello::Greeting {
            message: format!("Hello, {}", message),
        };

        Ok(Response::new(reply))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::1]:50051".parse()?;
    let greeter_impl = GreeterImpl::default();

    Server::builder()
        .add_service(GreeterServer::new(greeter_impl))
        .serve(addr)
        .await?;

    Ok(())
}
