const hre = require("hardhat");

async function main() {
  const ChainBattles = await hre.ethers.getContractFactory("ChainBattles");
  const chainBattles = await ChainBattles.deploy();
  await chainBattles.deployed();
  console.log("ChainBattles deployed to ", chainBattles.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
