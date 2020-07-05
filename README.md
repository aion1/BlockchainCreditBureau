# Blockchain Credit Bureau
<h2>Needed before running</h2>
<h4>Ethereum:</h4>
<ul>
	<li><code>Ganache</code></li>
	<li><code>Truffle framework</code></li>
	<li>Update network section in <code>truffle-config.js</code> file to match the network specification of your<code>Ganache</code></li>
</ul>
<h4>Python version: <code>python 3.8.x</code></h4>
<h4>Python libraries:</h4>
<ul>
	<li><code>web3</code></li>	
	<li><code>django</code></li>	
	<li><code>mysqlclient</code></li>	
	<li><code>jupyter</code>(optionally)</li>	
</ul>
<h2>To run:</h2></br>
<ol>
<li>Launch <code>Ganache</code></li>
<li>Compile smart contracts. Inside <code>Solidity/</code>
<ul>
	<li><code>$ truffle compile</code></li>
	<li><code>$ truffle deploy</code></li>
</ul>
</li>
<li> Update <code>mysql</code> credentials in <code>setting.py</code> file to match yours</li>
<li> Grant all privileges to your account on database in <code>settings.py</code></li>
<li> Start your <code>mysql server</code></li>
<li>Start you <code>django</code> server</li>
</ol>
