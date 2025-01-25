# Identifying Public and Private Keys

**Understanding Key Pairs**

* **Public Key:** 
    * Used to encrypt data. 
    * Can be freely shared with others.
    * Used to verify digital signatures.

* **Private Key:** 
    * Used to decrypt data encrypted with the corresponding public key.
    * Must be kept secret.
    * Used to create digital signatures.

**File Extensions and Key Types**

* **.cer:** 
    * Typically represents a **certificate** file. 
    * Certificates usually contain a **public key** and other relevant information (like issuer, validity period).

* **.pem:** 
    * A common file format for storing cryptographic keys. 
    * Can contain either a **public key** or a **private key**. 
    * The actual key type within a .pem file depends on its contents.

**Determining Key Types**

1. **Inspect File Contents:**
    * Use a text editor (like Notepad, Sublime Text, or VS Code) to open the .pem file. 
    * Look for keywords like "BEGIN PUBLIC KEY" or "BEGIN RSA PRIVATE KEY" within the file. 
        * If you find "BEGIN PUBLIC KEY", it's likely a public key.
        * If you find "BEGIN RSA PRIVATE KEY", it's definitely a private key.

2. **Use a Command-Line Tool:**
    * **openssl:** A powerful command-line tool for working with cryptographic keys. 
        * You can use `openssl rsa -in your_key.pem -text -noout` to display the key details in a human-readable format. 

**Example (using OpenSSL)**

```openssl rsa -in your_key.pem -text -noout ```

This command will:

Read the key from your_key.pem.
Print the key details in a human-readable format.
You can then inspect the output to determine if it's a public or private key.
Important Notes:

- **Security: ** Always handle private keys with extreme care.
- **File Naming:** While .cer and .pem can provide hints, file extensions alone are not always reliable indicators of key type.
- **Context:** The intended use of the keys and the surrounding application logic often provide the best clues.

# Converting a .pem & .cer file pair into .jks file


Adding a private key to a **Java KeyStore (JKS)** requires the following steps. A JKS file typically stores private keys, public keys, and certificates in a secure, password-protected format. Below is a step-by-step guide:

## # 1. Prerequisites
Before you begin, make sure you have the following:

- **Private key:** A .pem or .key file that contains your private key.
- **Certificate:** A .pem or .cer file containing the certificate that corresponds to the private key.
- **Keytool utility:** A tool included with the JDK, used to manage JKS files.


------------

## # 2. Combine the Private Key and Certificate
The private key and certificate must be combined into a PKCS#12 file (.p12 or .pfx), as keytool does not directly accept separate private key files.

You can use OpenSSL to create a PKCS#12 file:

```openssl pkcs12 -export -inkey private_key.pem -in certificate.pem -name alias_name -out keystore.p12```

- inkey private_key.pem: Path to the private key file.
- in certificate.pem: Path to the certificate file.
- name alias_name: Alias name for the entry in the keystore.
- out keystore.p12: Output file in PKCS#12 format.

You’ll be prompted to set a password for the PKCS#12 file. Remember this password for the next step.


------------

## 3. Import the PKCS#12 File into a JKS

Use the keytool utility to import the .p12 file into a JKS keystore.

Command:


  ```keytool -importkeystore \```
  ```-srckeystore keystore.p12 \```
  ```-srcstoretype PKCS12 \```
  ```-srcalias alias_name \```
  ```-destkeystore keystore.jks \```
  ```-deststoretype JKS \```
  ```-destalias alias_name```

**Parameters:**
- srckeystore keystore.p12: Specifies the input PKCS#12 file.
- srcstoretype PKCS12: Indicates the source keystore type.
- srcalias alias_name: Alias for the entry in the source keystore.
- destkeystore keystore.jks: Specifies the output JKS file.
- deststoretype JKS: Sets the output keystore type to JKS.
- destalias alias_name: Alias for the entry in the JKS.

You will be prompted for:

1. The password of the .p12 file (set in step 2).
2. A new password for the JKS keystore.

## 4. Verify the Keystore
To ensure the private key and certificate were successfully added to the JKS, list its contents:


```keytool -list -keystore keystore.jks```

You should see the alias you used (alias_name) in the output.

## 5. Example

Example Commands:
1. Combine the private key and certificate:

```openssl pkcs12 -export -inkey private_key.pem -in certificate.pem -name myalias -out keystore.p12```

2. Import the .p12 file into a JKS:

```keytool -importkeystore \
  -srckeystore keystore.p12 \
  -srcstoretype PKCS12 \
  -srcalias myalias \
  -destkeystore mykeystore.jks \
  -deststoretype JKS \
  -destalias myalias```
  
3. Verify the JKS:

```keytool -list -keystore mykeystore.jks```

### Notes
If your private key is encrypted, OpenSSL will prompt you for the decryption password when running the pkcs12 -export command.
Ensure you securely store the passwords used for both the .p12 file and the JKS keystore.


