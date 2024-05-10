pub mod auth;
pub mod demo;

use std::sync::Arc;

use auth::{auth_interceptor::AuthInterceptor, auth_handler::AuthHandlerImpl};
use demo::{
    demo_service_server::DemoServiceServer, no_auth_demo_service_server::NoAuthDemoServiceServer,
};

use demo_impl::{DemoImpl, NoAuthDemoImpl};
use tonic::transport::Server;
use tonic_middleware::InterceptorFor;

mod demo_impl;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::1]:50051".parse()?;

    let auth_interceptor = AuthInterceptor {
        auth_service: Arc::new(AuthHandlerImpl::default()),
    };

    Server::builder()
        .add_service(InterceptorFor::new(
            DemoServiceServer::new(DemoImpl::default()),
            auth_interceptor,
        ))
        .add_service(NoAuthDemoServiceServer::new(NoAuthDemoImpl::default()))
        .serve(addr)
        .await?;

    Ok(())
}
