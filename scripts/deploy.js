const { ethers, upgrades } = require("hardhat");

async function main() {
  const CustomERC721 = await ethers.getContractFactory("CustomERC721");
  const customERC721 = await upgrades.deployProxy(CustomERC721);
  await customERC721.deployed();
  console.log("Contract address:", customERC721.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
