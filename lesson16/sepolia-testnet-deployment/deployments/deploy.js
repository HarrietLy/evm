async function main() {
    const Greeting = await ethers.getContractFactory("Greeter");
    const greeting = await Greeting.deploy("Greeting!");
    console.log("Contract Deployed to Address:", greeting.address);
  }
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
  