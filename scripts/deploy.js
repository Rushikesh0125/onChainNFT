const hre = require("hardhat");

async function main() {
  const gameChar = await hre.ethers.getContractFactory("onChainGameChar");
  const gamechar = await gameChar.deploy();

  await gamechar.deployed();

  console.log(` ${gamechar} deployed to ${gamechar.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
