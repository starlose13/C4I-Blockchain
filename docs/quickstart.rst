Getting Started
===============

Welcome to the Next-Generation Command and Control project! This guide will walk you through setting up your development environment, configuring the project, and deploying smart contracts. Whether you're a seasoned developer or just getting started, this guide will help you get up to speed quickly.

1. **Introduction**
--------------------

This project leverages the Foundry framework for smart contract development and deployment, offering a robust platform for creating and managing blockchain-based solutions. The system includes various scripts and tools for deploying smart contracts to multiple networks and integrating them into our Command and Control system.

.. _prerequisites:

2. **Prerequisites**
---------------------

Before you start, make sure you have the following tools installed:

- **Foundry**: A framework for smart contract development. Follow the installation guide at `Foundry's Documentation <https://book.getfoundry.sh/>`_.
- **Python**: Required for Sphinx documentation (if you plan to build it).
- **Node.js**: Necessary for certain development tasks.
- **Git**: For version control and collaboration.

.. _setting_up_environment:

3. **Setting Up Your Environment**
------------------------------------

1. **Clone the Repository**

   First, clone the project repository to your local machine:

   .. code-block:: bash

      git clone https://github.com/starlose13/C4I-Blockchain.git
      cd C4I-Blockchain

2. **Create and Activate a Virtual Environment (Optional)**

   This step ensures that your project's dependencies are isolated:

   .. code-block:: bash

      python -m venv venv
      source venv/bin/activate  # On Windows: venv\Scripts\activate

3. **Install Dependencies**

   Install Foundry and any project-specific dependencies. If there are additional Python dependencies, install them using:

   .. code-block:: bash

      forge install
      pip install -r requirements.txt

4. **Create an Environment File**

   Set up a `.env` file in the root directory with your network configurations and keys:

   .. code-block::

      HOLESKY_RPC_URL=your_holesky_rpc_url
      FANTOM_RPC_URL=your_fantom_rpc_url
      AMOY_RPC_URL=your_amoy_rpc_url
      VITE_RPC_URL=your_vite_rpc_url
      PRIVATE_KEY=your_private_key
      ETHERSCAN_API_KEY=your_etherscan_api_key
      FANTOMSCAN_API_KEY=your_fantomscan_api_key

.. _configuration:

4. **Project Configuration**
----------------------------

1. **Modify the `Makefile`**

   Ensure the paths and commands in the `Makefile` match your project's structure and network requirements. The `Makefile` includes targets for deploying smart contracts and version control.

2. **Configure Sphinx Documentation**

   Update `conf.py` to correctly reference static files and themes for building the project documentation.

5. **Building and Running the Project**
----------------------------------------

1. **Build Documentation**

   To build the HTML documentation, use:

   .. code-block:: bash

      make html

   This command generates the documentation in the `docs/_build/html/` directory.

2. **Run Foundry Commands**

   Execute Foundry commands to interact with and manage your smart contracts:

   .. code-block:: bash

      forge test
      forge build

.. _deployment:

6. **Deploying Smart Contracts**
---------------------------------

1. **Deploy Specific Contracts**

   Deploy the Node Manager smart contract:

   .. code-block:: bash

      make deploy-nm ARGS= "--network <name>"

   Deploy the Consensus Mechanism smart contract:

   .. code-block:: bash

      make deploy-cm ARGS= "--network <name>"

   Deploy integrated scripts:

   .. code-block:: bash

      make deploy-contract ARGS= "--network <name>"

2. **Deploy and Commit Changes**

   To deploy and automatically commit changes to Git:

   .. code-block:: bash

      make deploy-and-commit-nodeManager ARGS= "--network <name>"

.. _troubleshooting:

7. **Common Tasks**
--------------------

1. **Add, Commit, and Push Changes**

   Use the following commands to manage your Git repository:

   .. code-block:: bash

      make git-add-commit-push ARGS= "--network <name>"

2. **Troubleshoot Build Issues**

   If you encounter issues, check:

   - **File Paths**: Ensure all paths in the `Makefile` and scripts are correct.
   - **Environment Variables**: Verify the `.env` file for accurate configurations.
   - **Logs**: Review build logs for specific error messages and seek solutions or consult Foundry's documentation.

8. **Additional Tips for Beginners**
--------------------------------------

1. **Understanding the Project Structure**

   Familiarize yourself with the project's directory layout, including where scripts, smart contracts, and documentation are located.

2. **Learning Foundry**

   Spend some time exploring Foundry's documentation to understand its features and commands. This will help you use it more effectively.

3. **Experimenting Safely**

   If you're new to smart contract development, consider creating a test network or using local development environments to experiment without risking real assets.

4. **Seek Help**

   If you run into issues, don’t hesitate to reach out to the community or ask for help in forums. You can also contact support at [your-email@example.com](mailto:your-email@example.com) for additional assistance.

9. **Contact and Support**
----------------------------

For any questions or support, please contact us at [starlose13@gmail.com].
