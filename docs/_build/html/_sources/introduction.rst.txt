Introduction
============

Proposed Network Components
---------------------------

The proposed network can be divided into three main components:

1. **Distributed Ledger (Blockchain)**
2. **Smart Contracts: Consensus Mechanism and Node Management**
3. **Security (Asymmetric Cryptography)**

Public Key Management and Security
-----------------------------------

Each agent or device that wishes to participate in writing/reading on the blockchain-based platform must have its public key listed in the authorized agent list within the smart contract. Additionally, messages and interactions must be secured against potential attackers. Asymmetric cryptography is used to protect agent data within the network. Messages and interactions (local models) from each agent are first secured using a private key and can only be read with the public key of the same agent. Each agent also has a public key that serves as a type of cryptographic address, allowing other members of the swarm to interact with it.

.. image:: ./_static/communication-concept.png
   :alt: Description of the image
   :width: 600px
   :align: center
..
In the cryptographic method mentioned, private keys are used to digitally sign each transaction performed by the agent. However, in blockchain technology, although messages encrypted with a user's private key are accessible to other users through their public key, achieving consensus among users without the need for the same private key is a distinguishing factor. The larger the number of swarm members, the more decentralized the network becomes, which enhances security.

Transaction Process
-------------------

When two or more nodes or agents in the network want to transfer or share information, such as battlefield data, trained AI models, etc., which are primary information reports from the agent's perspective, they must go through a process known as a transaction. When a transaction occurs, a node creates a file containing information and target location. These transactions are collected into blocks of transactions, with the block size depending on the application. The blocks are then confirmed and added to the blockchain according to the used consensus mechanism.

Each agent collects environmental data based on sensor specifications and situational awareness of the battlefield, considering sensor limitations. The collected data is processed by environmental agents, and each agent independently broadcasts its decision in the network.

Consensus Process
-----------------

After an agent announces a target, other agents present in the network must also announce their targets within an epoch (approximately 10 minutes). They can also declare that there is no target. After the epoch concludes, the votes from participating agents are counted. If a quorum is reached, consensus is achieved. Consensus is calculated using the following formula:

.. math::

    C_j = \sum_{i=1}^{N} \text{if } Z_i = j \text{ then } 1 \text{ else } 0

Find the maximum count and its index:

.. math::

    \text{maxCount} = \max(C_1, C_2, C_3, C_4, C_5, C_6, C_7)

.. note::

   **Important:** We have assumed that number of agents is 7.

If consensus is achieved, the final target is announced to all parties. Otherwise, it is announced that either the votes did not reach a quorum or no consensus was reached in that specific epoch.
