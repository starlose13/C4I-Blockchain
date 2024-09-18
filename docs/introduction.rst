Introduction
============

Network Architecture
--------------------

The proposed decentralized communication network is composed of three integral components, each playing a crucial role in ensuring secure, reliable, and efficient operation:

1. **Distributed Ledger (Blockchain)**: Acts as the immutable ledger, recording all transactions and state changes. This ensures transparency and tamper-proof data storage.
2. **Smart Contracts for Consensus and Node Management**: Automate network governance and facilitate consensus on the network's state, managing node participation and enforcing rules.
3. **Security through Asymmetric Cryptography**: Provides a robust layer of security, ensuring data confidentiality, integrity, and authenticity.

Public Key Management and Security
----------------------------------

In this network, every participating agent or device must have its public key registered within the smart contract's authorized agent list. This requirement restricts access to only verified participants, maintaining network integrity and security.

Asymmetric Cryptography Mechanism
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Asymmetric cryptography is the cornerstone of the network's security architecture. Messages and interactions are encrypted using the agent's private key, ensuring that only the intended recipient can decrypt the data using the corresponding public key. This process not only secures the information but also serves as a digital signature, verifying the sender's identity.

Each agent has a unique cryptographic address, derived from their public key, enabling other network members to interact securely. The diagram below illustrates the communication concept within this secure framework:

.. image:: ./_static/communication-concept.png
   :alt: Communication Concept Diagram
   :width: 600px
   :align: center

Ensuring Transaction Integrity
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this cryptographic model, each transaction is digitally signed by the agent's private key, creating an immutable record. In blockchain technology, even though messages encrypted with a user's private key are accessible through their public key, the network achieves consensus without exposing private keys, which significantly enhances security. The network's decentralized nature, which increases with more participating agents, contributes to its robustness and security.

Transaction Workflow
--------------------

When agents within the network wish to exchange information—such as battlefield data, trained AI models, or other critical reports—they engage in a process known as a "transaction." The transaction workflow is outlined as follows:

1. **Transaction Creation**: An agent initiates a transaction by creating a file that contains the information and specifies the recipient(s). Each transaction includes metadata such as timestamps, unique identifiers, and cryptographic signatures.
2. **Block Formation**: Transactions are grouped into blocks. The block size is configured based on the network's application requirements. These blocks act as containers that hold transaction data in a sequential order.
3. **Consensus and Validation**: The network uses its consensus mechanism to validate these blocks. Only after a block is validated is it appended to the blockchain, ensuring data immutability and network-wide agreement.

Refer to the diagram below for a visual representation of the transaction process:

.. image:: ./_static/Transaction-process.png
   :alt: Transaction Process Diagram
   :width: 600px
   :align: center

Data Collection and Broadcast
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each agent autonomously collects environmental data, based on its sensors and situational awareness. This data is processed to form local decisions, which are then broadcasted to the network. This decentralized approach allows for efficient and secure data dissemination, even in dynamic environments.

Consensus Mechanism
-------------------

To maintain a consistent state across the network, a consensus mechanism is employed. This process ensures that all agents reach an agreement on the network's current state or on shared data, which is essential for maintaining network integrity.

1. **Target Identification**: An agent identifies and announces a target or event to the network within a designated epoch (e.g., 10 minutes).
2. **Voting and Verification**: Other network agents either confirm or dispute the announced target. They also have the option to declare the absence of a target if none is detected.
3. **Consensus Calculation**: Votes are tallied at the end of the epoch using a consensus algorithm:

   .. math::

       C_j = \sum_{i=1}^{N} \text{if } Z_i = j \text{ then } 1 \text{ else } 0

   The consensus algorithm identifies the index with the highest count:

   .. math::

       \text{maxCount} = \max(C_1, C_2, C_3, C_4, C_5, C_6, C_7)

   .. note::

      **Note:** This example assumes a network with 7 agents, but this number can be adjusted based on the network's scale.

4. **Final Outcome**: If a consensus is reached, the agreed-upon target or data is broadcast to all participants. If not, the network indicates that either the votes did not meet the quorum or no consensus was achieved in that epoch.

The following diagram provides an overview of the consensus process:
.. image:: ./_static/consensusProcess.png
   :alt: Consensus Process Diagram
   :width: 600px
   :align: center

Advanced Network Features
-------------------------

- **Fault Tolerance**: The consensus mechanism is designed to handle network faults, allowing operations to continue even if some agents are compromised or non-functional.
- **Scalability**: The system is built to accommodate a growing number of agents, ensuring the network can scale without performance degradation.
- **Enhanced Security**: Future network enhancements may include advanced cryptographic techniques like zero-knowledge proofs to further strengthen privacy and data protection.

By integrating these components and processes, the decentralized communication framework offers a secure, reliable, and scalable solution for environments where data integrity and authenticity are crucial.
