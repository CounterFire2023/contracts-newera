// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HasSignature is Ownable {
  mapping(bytes => bool) private _usedSignatures;

  function checkSigner(
    address signer,
    bytes32 hash,
    bytes memory signature
  ) public pure {
    bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(hash);

    address recovered = ECDSA.recover(ethSignedMessageHash, signature);
    require(recovered == signer, "[BE] invalid signature");
  }

  modifier signatureValid(bytes calldata signature) {
    require(
      !_usedSignatures[signature],
      "[BE] signature used. please send another transaction with new signature"
    );
    _;
  }

  function _useSignature(bytes calldata signature) internal {
    if (!_usedSignatures[signature]) {
      _usedSignatures[signature] = true;
    }
  }
}
