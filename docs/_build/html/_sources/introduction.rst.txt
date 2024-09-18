Introduction
============

Proposed Network Components
---------------------------

The proposed network is structured into three key components that collectively form a robust and secure decentralized communication framework:

1. **Distributed Ledger (Blockchain)**: Serves as the immutable and transparent backbone of the network, recording all transactions and state changes in a tamper-proof manner.
2. **Smart Contracts: Consensus Mechanism and Node Management**: Implemented to automate network governance, manage node participation, and ensure reliable consensus on the state of the network.
3. **Security (Asymmetric Cryptography)**: Provides a secure layer for authentication and data integrity, protecting the network against unauthorized access and ensuring the confidentiality of communications.

Public Key Management and Security
----------------------------------

To maintain a high level of security and authenticity within the network, every agent or device that participates in the blockchain-based platform must have its public key registered in the authorized agent list within the smart contract. This measure ensures that only verified participants can interact with the network.

### Asymmetric Cryptography

The network employs asymmetric cryptography to safeguard agent data. Messages and interactions are encrypted using the agent's private key, ensuring that only the intended recipient can decrypt and read the information with the corresponding public key. This cryptographic approach not only secures the data but also serves as a digital signature, verifying the authenticity of the sender.

Each agent possesses a unique cryptographic address derived from their public key. This address allows other network members to interact securely with the agent. The following diagram illustrates the communication concept within this secure framework:

.. image:: ./_static/communication-concept.png
   :alt: Communication Concept Diagram
   :width: 600px
   :align: center

### Transaction Integrity

In this cryptographic system, every transaction is digitally signed by the agent's private key, providing an immutable record of the interaction. Unlike traditional systems, blockchain technology allows these transactions to be verified publicly through the agent's public key. This mechanism enables consensus without exposing the private keys, enhancing security through decentralization. As the network grows in size and diversity of agents, its decentralized nature contributes to increased robustness and security.

Transaction Process
-------------------

When nodes or agents within the network wish to transfer or share information, they initiate a process called a "transaction." This could involve sharing data such as battlefield reports, trained AI models, or other critical information. Here's how the process unfolds:

1. **Transaction Creation**: An agent generates a transaction file containing the information and intended recipient(s). Each transaction includes metadata like timestamps, unique identifiers, and cryptographic signatures.
2. **Block Formation**: Transactions are bundled into blocks, with the block size tailored to the network's application requirements. These blocks serve as containers that hold the transaction data in a sequential manner.
3. **Consensus and Validation**: Using the network's consensus mechanism, blocks are validated by network nodes. Only after a block is validated is it appended to the blockchain, ensuring that the information is immutable and has been agreed upon by the network.

The following diagram illustrates the transaction process:

.. image:: ./_static/Transaction-process.png
   :alt: Transaction Process Diagram
   :width: 600px
   :align: center

### Data Collection and Dissemination

Each agent autonomously gathers environmental data based on its sensor inputs and situational awareness. This data is then processed to form a local decision, which is broadcast to the network. This decentralized approach to data collection and dissemination ensures that the network operates efficiently and securely, even in dynamic environments.

Consensus Process
-----------------

To reach a network-wide agreement on shared data or state changes, a consensus process is employed. This process ensures that all agents agree on a single source of truth, which is critical for maintaining the integrity and reliability of the network.

1. **Target Announcement**: After an agent identifies a target or event, it announces this information to the network within a designated epoch (approximately 10 minutes).
2. **Voting and Validation**: Other agents within the network either confirm or dispute the announced target. They can also declare the absence of a target if none is detected.
3. **Consensus Calculation**: At the end of the epoch, votes are tallied using a consensus algorithm. The following formula is used to determine consensus:

   .. math::

       C_j = \sum_{i=1}^{N} \text{if } Z_i = j \text{ then } 1 \text{ else } 0

   The index with the maximum count is identified:

   .. math::

       \text{maxCount} = \max(C_1, C_2, C_3, C_4, C_5, C_6, C_7)

   .. note::

      **Important:** This example assumes that the number of agents is 7, which can vary based on the network configuration.

4. **Final Decision**: If consensus is achieved, the agreed-upon target or data is broadcast to all network participants. If not, the network announces that no consensus was reached or the quorum was not met within the epoch.

The following diagram depicts the consensus process:

.. image:: ./_static/consensusProcess.png
   :alt: Consensus Process Diagram
   :width: 600px
   :align: center

### Advanced Considerations

- **Fault Tolerance**: The consensus mechanism is designed to be fault-tolerant, allowing the network to continue operating even if some agents are compromised or malfunctioning.
- **Scalability**: The consensus process is optimized to handle an increasing number of agents, ensuring that the network can scale without compromising on performance or security.
- **Security Enhancements**: In addition to asymmetric cryptography, future iterations of the network may incorporate advanced cryptographic techniques such as zero-knowledge proofs to further enhance privacy and security.

By implementing these processes and mechanisms, the decentralized communication framework ensures secure, reliable, and efficient information exchange across the network, making it suitable for high-stakes environments where data integrity and authenticity are paramount.
