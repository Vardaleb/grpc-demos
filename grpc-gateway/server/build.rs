
fn main() -> Result<(), Box<dyn std::error::Error>> {
    tonic_build::configure().compile(
        &["../proto/v1/hello.proto"],
        &["../proto/v1"],
    )?;
    Ok(())
}