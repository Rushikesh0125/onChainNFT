const hre = require("hardhat");

async function main() {
  const gameChar = await hre.ethers.getContractFactory("onChainGameChar");
  const gamechar = await gameChar.deploy();

  await gamechar.deployed();

  console.log(` ${gamechar} deployed to ${gamechar.address}`);
  console.log("Verify Contract Address:", gamechar.address);

  console.log("Sleeping.....");
  // Wait for etherscan to notice that the contract has been deployed
  await sleep(40000);

  // Verify the contract after deploying
  await hre.run("verify:verify", {
    address: gamechar.address,
    constructorArguments: [],
  });
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
