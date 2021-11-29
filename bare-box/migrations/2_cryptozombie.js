const erc721 = artifacts.require("IERC721");
const safemath = artifacts.require("SafeMath");
const zombie_factory = artifacts.require("ZombieFactory");
const zombie_helper = artifacts.require("ZombieHelper");
const zombie_upgrader = artifacts.require("ZombieUpgrader");
const zombie_core = artifacts.require("ZombieCore");

module.exports = function(deployer) {
  // deployer.deploy(crowd);
  // deployer.deploy(erc721);
  // deployer.deploy(safemath);
  // deployer.deploy(zombie_factory);
  // deployer.deploy(zombie_helper);
  deployer.deploy(zombie_core);
};
