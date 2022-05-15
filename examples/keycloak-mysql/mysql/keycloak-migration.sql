-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: localhost    Database: keycloak
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ADMIN_EVENT_ENTITY`
--

DROP TABLE IF EXISTS `ADMIN_EVENT_ENTITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ADMIN_EVENT_ENTITY` (
  `ID` varchar(36) NOT NULL,
  `ADMIN_EVENT_TIME` bigint DEFAULT NULL,
  `REALM_ID` varchar(255) DEFAULT NULL,
  `OPERATION_TYPE` varchar(255) DEFAULT NULL,
  `AUTH_REALM_ID` varchar(255) DEFAULT NULL,
  `AUTH_CLIENT_ID` varchar(255) DEFAULT NULL,
  `AUTH_USER_ID` varchar(255) DEFAULT NULL,
  `IP_ADDRESS` varchar(255) DEFAULT NULL,
  `RESOURCE_PATH` text,
  `REPRESENTATION` text,
  `ERROR` varchar(255) DEFAULT NULL,
  `RESOURCE_TYPE` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ADMIN_EVENT_ENTITY`
--

LOCK TABLES `ADMIN_EVENT_ENTITY` WRITE;
/*!40000 ALTER TABLE `ADMIN_EVENT_ENTITY` DISABLE KEYS */;
/*!40000 ALTER TABLE `ADMIN_EVENT_ENTITY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ASSOCIATED_POLICY`
--

DROP TABLE IF EXISTS `ASSOCIATED_POLICY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ASSOCIATED_POLICY` (
  `POLICY_ID` varchar(36) NOT NULL,
  `ASSOCIATED_POLICY_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`POLICY_ID`,`ASSOCIATED_POLICY_ID`),
  KEY `IDX_ASSOC_POL_ASSOC_POL_ID` (`ASSOCIATED_POLICY_ID`),
  CONSTRAINT `FK_FRSR5S213XCX4WNKOG82SSRFY` FOREIGN KEY (`ASSOCIATED_POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`),
  CONSTRAINT `FK_FRSRPAS14XCX4WNKOG82SSRFY` FOREIGN KEY (`POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ASSOCIATED_POLICY`
--

LOCK TABLES `ASSOCIATED_POLICY` WRITE;
/*!40000 ALTER TABLE `ASSOCIATED_POLICY` DISABLE KEYS */;
/*!40000 ALTER TABLE `ASSOCIATED_POLICY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AUTHENTICATION_EXECUTION`
--

DROP TABLE IF EXISTS `AUTHENTICATION_EXECUTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AUTHENTICATION_EXECUTION` (
  `ID` varchar(36) NOT NULL,
  `ALIAS` varchar(255) DEFAULT NULL,
  `AUTHENTICATOR` varchar(36) DEFAULT NULL,
  `REALM_ID` varchar(36) DEFAULT NULL,
  `FLOW_ID` varchar(36) DEFAULT NULL,
  `REQUIREMENT` int DEFAULT NULL,
  `PRIORITY` int DEFAULT NULL,
  `AUTHENTICATOR_FLOW` bit(1) NOT NULL DEFAULT b'0',
  `AUTH_FLOW_ID` varchar(36) DEFAULT NULL,
  `AUTH_CONFIG` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_AUTH_EXEC_REALM_FLOW` (`REALM_ID`,`FLOW_ID`),
  KEY `IDX_AUTH_EXEC_FLOW` (`FLOW_ID`),
  CONSTRAINT `FK_AUTH_EXEC_FLOW` FOREIGN KEY (`FLOW_ID`) REFERENCES `AUTHENTICATION_FLOW` (`ID`),
  CONSTRAINT `FK_AUTH_EXEC_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTHENTICATION_EXECUTION`
--

LOCK TABLES `AUTHENTICATION_EXECUTION` WRITE;
/*!40000 ALTER TABLE `AUTHENTICATION_EXECUTION` DISABLE KEYS */;
INSERT INTO `AUTHENTICATION_EXECUTION` VALUES ('00a8e2e1-4482-4499-8ff1-b4a055701bcc',NULL,'reset-credentials-choose-user','premier','6c360044-47d7-43c2-a0c6-bd0e0956bd53',0,10,_binary '\0',NULL,NULL),('05b35d23-ee98-4f5c-8194-8c802cef4cc3',NULL,'auth-otp-form','master','f3ccf331-d0f2-44f4-843e-476962e6a5ec',0,20,_binary '\0',NULL,NULL),('0693f63b-cb81-4cda-9a53-e164d1322874',NULL,'basic-auth','premier','b233a524-5b27-4013-9f0d-794550488066',0,10,_binary '\0',NULL,NULL),('07697cbd-1b7c-42cd-af75-20f5b5f936fb',NULL,'client-x509','master','efc1cf9c-85db-426d-a393-1ecda3c9acf1',2,40,_binary '\0',NULL,NULL),('08115098-eef6-46b7-a173-f7b55dbbb511',NULL,'conditional-user-configured','master','2c8bb219-a6b6-4b52-a9f0-5851707b9545',0,10,_binary '\0',NULL,NULL),('0d137ec0-929a-499a-b1aa-7757fa7d7ec4',NULL,'conditional-user-configured','master','847c637c-c2ea-404c-b1f2-82c5b4994a11',0,10,_binary '\0',NULL,NULL),('0fa47778-1064-4593-b729-16a1ca32cbb3',NULL,'client-secret','premier','d15d2c19-16e2-4ac4-aceb-d896cf92afc5',2,10,_binary '\0',NULL,NULL),('1439a4ae-23c7-4f73-93b0-2f036bc93906',NULL,'registration-password-action','premier','c0ea5c14-4b11-439d-a91a-24a6bef29b66',0,50,_binary '\0',NULL,NULL),('15190552-f895-4bf1-909e-fac070cb236b',NULL,NULL,'master','ee307d34-faf5-45db-926e-dba9fe96e260',1,40,_binary '','33eae15f-c7a9-4561-91f9-a378f18ab6c7',NULL),('174e2d65-5043-481a-87a7-72d941e2d4f1',NULL,'idp-email-verification','premier','bd7f934d-eb27-4f8d-b926-db5e6fa04f5e',2,10,_binary '\0',NULL,NULL),('17a53eed-089b-4066-a378-3fbabc989f5b',NULL,'auth-username-password-form','master','ed339ca9-ecdd-4b8c-9b23-f4480cbafa3e',0,10,_binary '\0',NULL,NULL),('18a38cd1-8672-40e7-a815-671c1a5b9343',NULL,'client-x509','premier','d15d2c19-16e2-4ac4-aceb-d896cf92afc5',2,40,_binary '\0',NULL,NULL),('193a1338-904c-4c2d-ab77-ea3bcaa74631',NULL,'conditional-user-configured','premier','8c4572ae-bd4c-477b-8fb3-55cd0ad0c8bc',0,10,_binary '\0',NULL,NULL),('1b3a51ae-cfff-4ccb-8bf3-a3599ce70163',NULL,'conditional-user-configured','premier','3e18d014-2be0-4424-ba71-336be26a1313',0,10,_binary '\0',NULL,NULL),('1e5858f7-3996-4f0f-997d-bd09f9a11f44',NULL,NULL,'master','ce107784-ca2c-4967-a172-e5e6b793a44a',2,20,_binary '','10ed54fa-6a0b-40f5-8fe5-b5dc6bca9218',NULL),('1fa23175-75d7-4bb4-ac9f-9e0c79b54a7d',NULL,'idp-username-password-form','master','f12288d8-6dba-40e0-9813-ed4cfe926b09',0,10,_binary '\0',NULL,NULL),('21af4702-3a6a-4ac3-8d2f-47831cdf5167',NULL,'reset-otp','master','33eae15f-c7a9-4561-91f9-a378f18ab6c7',0,20,_binary '\0',NULL,NULL),('21c2076f-e69e-45cf-a9d1-379817d53e16',NULL,'basic-auth-otp','premier','b233a524-5b27-4013-9f0d-794550488066',3,20,_binary '\0',NULL,NULL),('233d907a-dc10-4bde-9ad5-01c8d8e49188',NULL,'no-cookie-redirect','master','e84b643f-d1c8-4857-9655-bbf842547294',0,10,_binary '\0',NULL,NULL),('25463c00-0617-4bb0-bb3c-d21616f717bb',NULL,NULL,'master','0b2aa82f-7636-4a21-a7e4-e61cc6e7747a',2,20,_binary '','f12288d8-6dba-40e0-9813-ed4cfe926b09',NULL),('273b947f-9e55-45e9-98e3-27f90e54c19a',NULL,'basic-auth','master','78d8946e-65f4-4c31-825c-b082e0e7b383',0,10,_binary '\0',NULL,NULL),('27fad18b-bd92-470d-b9fb-671de4579e59',NULL,'auth-spnego','premier','b233a524-5b27-4013-9f0d-794550488066',3,30,_binary '\0',NULL,NULL),('2959eedd-570b-4ad0-8842-01851922b705',NULL,'reset-credential-email','master','ee307d34-faf5-45db-926e-dba9fe96e260',0,20,_binary '\0',NULL,NULL),('2ab3bed7-8445-45b7-a7bf-79105649b1da',NULL,'client-secret-jwt','master','efc1cf9c-85db-426d-a393-1ecda3c9acf1',2,30,_binary '\0',NULL,NULL),('38798b94-23aa-40f6-a12a-b1b5a7f2f72a',NULL,'conditional-user-configured','master','f3ccf331-d0f2-44f4-843e-476962e6a5ec',0,10,_binary '\0',NULL,NULL),('3bf10629-f0f2-40bf-8bd6-b0ffd33d40a6',NULL,NULL,'premier','77a1d988-6bb3-4781-8498-d4e6fcb39542',1,20,_binary '','8c4572ae-bd4c-477b-8fb3-55cd0ad0c8bc',NULL),('416a11fe-1e00-413c-892a-3bf647b49f95',NULL,'basic-auth-otp','master','78d8946e-65f4-4c31-825c-b082e0e7b383',3,20,_binary '\0',NULL,NULL),('4a489301-3e2d-4235-b831-fcf5f804a6f2',NULL,'idp-username-password-form','premier','54b8789a-85d2-4a7e-9357-22b4f81e743a',0,10,_binary '\0',NULL,NULL),('4bab4d10-ccc0-48e6-991f-f8c46adf6587',NULL,NULL,'premier','6c360044-47d7-43c2-a0c6-bd0e0956bd53',1,40,_binary '','d7292ba5-cec1-48ca-91a3-bcb47454bdfb',NULL),('4f89565c-64a9-4da2-b20c-2d0f8624af4c',NULL,'reset-password','master','ee307d34-faf5-45db-926e-dba9fe96e260',0,30,_binary '\0',NULL,NULL),('50bdbd07-8890-44b0-a3ef-0b7aff726437',NULL,'client-secret-jwt','premier','d15d2c19-16e2-4ac4-aceb-d896cf92afc5',2,30,_binary '\0',NULL,NULL),('5245970c-44b8-4c87-b5d0-694247d15a1c',NULL,'auth-otp-form','premier','432c83e3-ea32-44f2-a473-518527401fa4',0,20,_binary '\0',NULL,NULL),('5259a18c-65eb-4995-85db-9fab38128d88',NULL,'registration-user-creation','master','4f213c47-d8b5-49f3-bcd3-a749bd1e7ce1',0,20,_binary '\0',NULL,NULL),('527adf51-d22d-4063-9c45-267e8d7c10c3',NULL,'identity-provider-redirector','master','18d5447f-78ef-4e1b-9eda-a30a8add1db5',2,25,_binary '\0',NULL,NULL),('554758ef-8015-4556-8c68-a979184c46ec',NULL,'idp-confirm-link','master','10ed54fa-6a0b-40f5-8fe5-b5dc6bca9218',0,10,_binary '\0',NULL,NULL),('57551d63-c28e-4a10-8409-76bf4d3cfb37',NULL,'conditional-user-configured','premier','d7292ba5-cec1-48ca-91a3-bcb47454bdfb',0,10,_binary '\0',NULL,NULL),('5b7913f8-a3d6-4c8c-89e3-f5d5fb35014c',NULL,NULL,'master','f12288d8-6dba-40e0-9813-ed4cfe926b09',1,20,_binary '','2c8bb219-a6b6-4b52-a9f0-5851707b9545',NULL),('5cb34480-5383-4d20-9514-c68783fbc9a5',NULL,'auth-cookie','premier','ee47c2c7-d606-4654-9b9a-739cdfb2f792',2,10,_binary '\0',NULL,NULL),('5e0ecf3c-d009-4ff5-8ae2-088e483c2e03',NULL,'reset-credentials-choose-user','master','ee307d34-faf5-45db-926e-dba9fe96e260',0,10,_binary '\0',NULL,NULL),('645f85e2-0862-49ad-bc3a-a7ea98806172',NULL,NULL,'premier','3014f6a9-f328-4c4a-97e1-3b1cf928360c',1,30,_binary '','3e18d014-2be0-4424-ba71-336be26a1313',NULL),('671564e4-4dde-4534-a55b-da52f027db53',NULL,NULL,'premier','9881d6cf-2429-42b0-a801-8ad6bd6cc8ba',0,20,_binary '','a7ac43cd-d367-408f-b6fc-ad62a70104ba',NULL),('67be4c43-1dfa-4646-8551-928f3d16bc63',NULL,NULL,'master','ed339ca9-ecdd-4b8c-9b23-f4480cbafa3e',1,20,_binary '','f3ccf331-d0f2-44f4-843e-476962e6a5ec',NULL),('67be8879-a3a6-4fda-8f51-b945ec22ef88',NULL,NULL,'premier','0915d020-9869-4bc0-b904-be30fc64081e',0,20,_binary '','b233a524-5b27-4013-9f0d-794550488066',NULL),('7558330b-6107-4fc8-ba87-8daa3ba5ecbd',NULL,'direct-grant-validate-otp','premier','3e18d014-2be0-4424-ba71-336be26a1313',0,20,_binary '\0',NULL,NULL),('75801626-00fb-4844-9946-e33ee83c9988',NULL,'auth-otp-form','master','2c8bb219-a6b6-4b52-a9f0-5851707b9545',0,20,_binary '\0',NULL,NULL),('7f471935-b53f-4039-bdc1-0e43c7e52f2d',NULL,'registration-password-action','master','4f213c47-d8b5-49f3-bcd3-a749bd1e7ce1',0,50,_binary '\0',NULL,NULL),('8ff232e8-803b-499c-ba8f-478040c055a6',NULL,'auth-otp-form','premier','8c4572ae-bd4c-477b-8fb3-55cd0ad0c8bc',0,20,_binary '\0',NULL,NULL),('924ea36f-392e-407c-88f5-7a7cb5476073',NULL,NULL,'master','d9d8b731-7bd9-49b4-a6ee-fd8206198747',1,30,_binary '','847c637c-c2ea-404c-b1f2-82c5b4994a11',NULL),('936ed8c9-5ef3-4a49-846b-03a1a1d92981',NULL,NULL,'master','e84b643f-d1c8-4857-9655-bbf842547294',0,20,_binary '','78d8946e-65f4-4c31-825c-b082e0e7b383',NULL),('9acb927b-5830-4652-bfc4-b4512ea1d416',NULL,'client-jwt','master','efc1cf9c-85db-426d-a393-1ecda3c9acf1',2,20,_binary '\0',NULL,NULL),('9b7c2044-97ac-4492-ac97-91f58d03f7fa',NULL,'reset-otp','premier','d7292ba5-cec1-48ca-91a3-bcb47454bdfb',0,20,_binary '\0',NULL,NULL),('9fb3b42b-3db4-4f2b-b657-e0fa3b9d377c',NULL,'auth-spnego','master','18d5447f-78ef-4e1b-9eda-a30a8add1db5',3,20,_binary '\0',NULL,NULL),('a30c4aa8-a520-480e-a855-6e0ec8073fdf',NULL,'idp-create-user-if-unique','master','ce107784-ca2c-4967-a172-e5e6b793a44a',2,10,_binary '\0',NULL,'f7ad49d1-79d8-48a3-88be-8e683f26b10f'),('a3d9838e-3bc9-4335-85c0-dc9857d28b81',NULL,'idp-email-verification','master','0b2aa82f-7636-4a21-a7e4-e61cc6e7747a',2,10,_binary '\0',NULL,NULL),('a648323e-9ac3-44b6-977d-ac1ec1f17e54',NULL,'direct-grant-validate-username','premier','3014f6a9-f328-4c4a-97e1-3b1cf928360c',0,10,_binary '\0',NULL,NULL),('a65e402d-ee43-496b-a826-c5715b51d09b',NULL,'client-jwt','premier','d15d2c19-16e2-4ac4-aceb-d896cf92afc5',2,20,_binary '\0',NULL,NULL),('aa649a62-9333-4fc7-b6b1-cde094ecd71d',NULL,'http-basic-authenticator','master','36e4c3bd-5601-4d98-818f-4b8abad2d547',0,10,_binary '\0',NULL,NULL),('ac732840-9557-4405-85f0-99a287c8cf51',NULL,'registration-recaptcha-action','master','4f213c47-d8b5-49f3-bcd3-a749bd1e7ce1',3,60,_binary '\0',NULL,NULL),('af9a1a0b-0abc-4db0-9414-89841ecfa8ab',NULL,'direct-grant-validate-password','premier','3014f6a9-f328-4c4a-97e1-3b1cf928360c',0,20,_binary '\0',NULL,NULL),('b095abca-a767-43dd-8d5a-aa3e782d94a0',NULL,'http-basic-authenticator','premier','6261481c-a4ae-40b0-b0e9-8b0c18c243bb',0,10,_binary '\0',NULL,NULL),('b7c2d528-10d2-401f-9fc2-bc0c5005af2e',NULL,'no-cookie-redirect','premier','0915d020-9869-4bc0-b904-be30fc64081e',0,10,_binary '\0',NULL,NULL),('b9dd112a-df49-4628-97cb-7fe4ec43b0b6',NULL,'auth-cookie','master','18d5447f-78ef-4e1b-9eda-a30a8add1db5',2,10,_binary '\0',NULL,NULL),('bc4870c9-ce21-48fa-b93a-eae307febd47',NULL,'conditional-user-configured','master','33eae15f-c7a9-4561-91f9-a378f18ab6c7',0,10,_binary '\0',NULL,NULL),('bc600d53-9a2f-43a6-8e55-7e525d3eb663',NULL,'registration-user-creation','premier','c0ea5c14-4b11-439d-a91a-24a6bef29b66',0,20,_binary '\0',NULL,NULL),('bc80f7b7-6040-49a7-9cdf-c356cb83fc03',NULL,'reset-password','premier','6c360044-47d7-43c2-a0c6-bd0e0956bd53',0,30,_binary '\0',NULL,NULL),('be8281d9-9d0e-4d1e-a0a6-54717b3d9bc1',NULL,'registration-profile-action','premier','c0ea5c14-4b11-439d-a91a-24a6bef29b66',0,40,_binary '\0',NULL,NULL),('c2c7c6e6-e1b2-4f7e-bb73-344b9d2ec3e3',NULL,'direct-grant-validate-otp','master','847c637c-c2ea-404c-b1f2-82c5b4994a11',0,20,_binary '\0',NULL,NULL),('c575cfd4-30ca-48d6-8594-f4ff68040422',NULL,'reset-credential-email','premier','6c360044-47d7-43c2-a0c6-bd0e0956bd53',0,20,_binary '\0',NULL,NULL),('cdee8ce7-2d87-45a6-800e-739c5cec9bd4',NULL,'registration-recaptcha-action','premier','c0ea5c14-4b11-439d-a91a-24a6bef29b66',3,60,_binary '\0',NULL,NULL),('cf31fd51-eab1-418e-890a-c248bfaf79e9',NULL,NULL,'premier','54b8789a-85d2-4a7e-9357-22b4f81e743a',1,20,_binary '','432c83e3-ea32-44f2-a473-518527401fa4',NULL),('cfa5ae95-812b-42f4-9841-0000cd646f94',NULL,'registration-page-form','master','d9a855c9-ee0c-4a7b-a952-640c90516002',0,10,_binary '','4f213c47-d8b5-49f3-bcd3-a749bd1e7ce1',NULL),('d346a59a-e093-41cc-a00d-f708b50e49af',NULL,NULL,'premier','bd7f934d-eb27-4f8d-b926-db5e6fa04f5e',2,20,_binary '','54b8789a-85d2-4a7e-9357-22b4f81e743a',NULL),('d3644306-f392-4e1b-b53c-3d4a44703c14',NULL,NULL,'premier','ee47c2c7-d606-4654-9b9a-739cdfb2f792',2,30,_binary '','77a1d988-6bb3-4781-8498-d4e6fcb39542',NULL),('d3b7e503-208e-4b3c-9dd7-583c62ab310b',NULL,'auth-spnego','premier','ee47c2c7-d606-4654-9b9a-739cdfb2f792',3,20,_binary '\0',NULL,NULL),('da1f6c27-a77b-42d9-b04b-ecdc245d9120',NULL,NULL,'master','b6f35d6f-a8a0-4259-be74-becb679b5223',0,20,_binary '','ce107784-ca2c-4967-a172-e5e6b793a44a',NULL),('dade8ad2-9f34-48a6-a2ff-a4c849673aac',NULL,'direct-grant-validate-username','master','d9d8b731-7bd9-49b4-a6ee-fd8206198747',0,10,_binary '\0',NULL,NULL),('db47c4f8-54e9-41e6-9455-951e3104ca9f',NULL,NULL,'master','18d5447f-78ef-4e1b-9eda-a30a8add1db5',2,30,_binary '','ed339ca9-ecdd-4b8c-9b23-f4480cbafa3e',NULL),('dc26c9b6-a6cb-4d49-9a75-cabdd76586dc',NULL,'docker-http-basic-authenticator','premier','b9b41305-4658-4725-b1bf-d05363a7a3d4',0,10,_binary '\0',NULL,NULL),('dfdbff9e-eae2-4ba6-b585-64f3b2dc77e6',NULL,'identity-provider-redirector','premier','ee47c2c7-d606-4654-9b9a-739cdfb2f792',2,25,_binary '\0',NULL,NULL),('e0740f9a-72cf-4a3d-b153-db04723c92bf',NULL,'docker-http-basic-authenticator','master','e7665ab0-dd72-4131-9f58-2e99c5e9a237',0,10,_binary '\0',NULL,NULL),('e2d845d3-f34c-4a35-8815-27d06ac136e5',NULL,'conditional-user-configured','premier','432c83e3-ea32-44f2-a473-518527401fa4',0,10,_binary '\0',NULL,NULL),('e6948037-3f7a-4023-9731-a9fdda4b0b94',NULL,'idp-review-profile','premier','9881d6cf-2429-42b0-a801-8ad6bd6cc8ba',0,10,_binary '\0',NULL,'b8a2ff68-6123-4de6-b538-abe3ad58ef44'),('e891121c-48e6-4870-b455-316931e67f96',NULL,'direct-grant-validate-password','master','d9d8b731-7bd9-49b4-a6ee-fd8206198747',0,20,_binary '\0',NULL,NULL),('eba622da-6c87-4494-8bb0-04df07ad4a74',NULL,'registration-profile-action','master','4f213c47-d8b5-49f3-bcd3-a749bd1e7ce1',0,40,_binary '\0',NULL,NULL),('ecca971c-ec9e-486b-b948-058c93b5448c',NULL,'idp-review-profile','master','b6f35d6f-a8a0-4259-be74-becb679b5223',0,10,_binary '\0',NULL,'33d0271b-749a-4a3e-9be9-85484e866f08'),('edfd504e-878e-4297-a816-08c0bd90fca7',NULL,'auth-username-password-form','premier','77a1d988-6bb3-4781-8498-d4e6fcb39542',0,10,_binary '\0',NULL,NULL),('ee60cbb5-537d-46b1-9644-88656157c983',NULL,'idp-create-user-if-unique','premier','a7ac43cd-d367-408f-b6fc-ad62a70104ba',2,10,_binary '\0',NULL,'182242a9-2b95-4daf-b25a-45301ed83d35'),('eef8d669-083c-4b8a-972e-7b5e84e4b688',NULL,NULL,'master','10ed54fa-6a0b-40f5-8fe5-b5dc6bca9218',0,20,_binary '','0b2aa82f-7636-4a21-a7e4-e61cc6e7747a',NULL),('ef7a033b-0e6e-4414-a6de-4a2dc87d372d',NULL,NULL,'premier','a7ac43cd-d367-408f-b6fc-ad62a70104ba',2,20,_binary '','e988806c-fd6e-426a-8266-475432c98d72',NULL),('f33b56fb-038b-4f75-854d-ebdf078ae4e1',NULL,'registration-page-form','premier','2ecd4887-fc55-4882-b43b-9c8ece1e856e',0,10,_binary '','c0ea5c14-4b11-439d-a91a-24a6bef29b66',NULL),('f7f9de13-bee1-4f5d-9a2e-ec1d58bf5292',NULL,NULL,'premier','e988806c-fd6e-426a-8266-475432c98d72',0,20,_binary '','bd7f934d-eb27-4f8d-b926-db5e6fa04f5e',NULL),('fa7ad954-8fee-4531-a24a-884fb5eb6cd1',NULL,'client-secret','master','efc1cf9c-85db-426d-a393-1ecda3c9acf1',2,10,_binary '\0',NULL,NULL),('fb25af94-a332-4525-bc32-492d7ffe00e4',NULL,'auth-spnego','master','78d8946e-65f4-4c31-825c-b082e0e7b383',3,30,_binary '\0',NULL,NULL),('fc81a8ca-9810-4ebb-802c-581a90618e38',NULL,'idp-confirm-link','premier','e988806c-fd6e-426a-8266-475432c98d72',0,10,_binary '\0',NULL,NULL);
/*!40000 ALTER TABLE `AUTHENTICATION_EXECUTION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AUTHENTICATION_FLOW`
--

DROP TABLE IF EXISTS `AUTHENTICATION_FLOW`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AUTHENTICATION_FLOW` (
  `ID` varchar(36) NOT NULL,
  `ALIAS` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `REALM_ID` varchar(36) DEFAULT NULL,
  `PROVIDER_ID` varchar(36) NOT NULL DEFAULT 'basic-flow',
  `TOP_LEVEL` bit(1) NOT NULL DEFAULT b'0',
  `BUILT_IN` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`ID`),
  KEY `IDX_AUTH_FLOW_REALM` (`REALM_ID`),
  CONSTRAINT `FK_AUTH_FLOW_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTHENTICATION_FLOW`
--

LOCK TABLES `AUTHENTICATION_FLOW` WRITE;
/*!40000 ALTER TABLE `AUTHENTICATION_FLOW` DISABLE KEYS */;
INSERT INTO `AUTHENTICATION_FLOW` VALUES ('0915d020-9869-4bc0-b904-be30fc64081e','http challenge','An authentication flow based on challenge-response HTTP Authentication Schemes','premier','basic-flow',_binary '',_binary ''),('0b2aa82f-7636-4a21-a7e4-e61cc6e7747a','Account verification options','Method with which to verity the existing account','master','basic-flow',_binary '\0',_binary ''),('10ed54fa-6a0b-40f5-8fe5-b5dc6bca9218','Handle Existing Account','Handle what to do if there is existing account with same email/username like authenticated identity provider','master','basic-flow',_binary '\0',_binary ''),('18d5447f-78ef-4e1b-9eda-a30a8add1db5','browser','browser based authentication','master','basic-flow',_binary '',_binary ''),('2c8bb219-a6b6-4b52-a9f0-5851707b9545','First broker login - Conditional OTP','Flow to determine if the OTP is required for the authentication','master','basic-flow',_binary '\0',_binary ''),('2ecd4887-fc55-4882-b43b-9c8ece1e856e','registration','registration flow','premier','basic-flow',_binary '',_binary ''),('3014f6a9-f328-4c4a-97e1-3b1cf928360c','direct grant','OpenID Connect Resource Owner Grant','premier','basic-flow',_binary '',_binary ''),('33eae15f-c7a9-4561-91f9-a378f18ab6c7','Reset - Conditional OTP','Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.','master','basic-flow',_binary '\0',_binary ''),('36e4c3bd-5601-4d98-818f-4b8abad2d547','saml ecp','SAML ECP Profile Authentication Flow','master','basic-flow',_binary '',_binary ''),('3e18d014-2be0-4424-ba71-336be26a1313','Direct Grant - Conditional OTP','Flow to determine if the OTP is required for the authentication','premier','basic-flow',_binary '\0',_binary ''),('432c83e3-ea32-44f2-a473-518527401fa4','First broker login - Conditional OTP','Flow to determine if the OTP is required for the authentication','premier','basic-flow',_binary '\0',_binary ''),('4f213c47-d8b5-49f3-bcd3-a749bd1e7ce1','registration form','registration form','master','form-flow',_binary '\0',_binary ''),('54b8789a-85d2-4a7e-9357-22b4f81e743a','Verify Existing Account by Re-authentication','Reauthentication of existing account','premier','basic-flow',_binary '\0',_binary ''),('6261481c-a4ae-40b0-b0e9-8b0c18c243bb','saml ecp','SAML ECP Profile Authentication Flow','premier','basic-flow',_binary '',_binary ''),('6c360044-47d7-43c2-a0c6-bd0e0956bd53','reset credentials','Reset credentials for a user if they forgot their password or something','premier','basic-flow',_binary '',_binary ''),('77a1d988-6bb3-4781-8498-d4e6fcb39542','forms','Username, password, otp and other auth forms.','premier','basic-flow',_binary '\0',_binary ''),('78d8946e-65f4-4c31-825c-b082e0e7b383','Authentication Options','Authentication options.','master','basic-flow',_binary '\0',_binary ''),('847c637c-c2ea-404c-b1f2-82c5b4994a11','Direct Grant - Conditional OTP','Flow to determine if the OTP is required for the authentication','master','basic-flow',_binary '\0',_binary ''),('8c4572ae-bd4c-477b-8fb3-55cd0ad0c8bc','Browser - Conditional OTP','Flow to determine if the OTP is required for the authentication','premier','basic-flow',_binary '\0',_binary ''),('9881d6cf-2429-42b0-a801-8ad6bd6cc8ba','first broker login','Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account','premier','basic-flow',_binary '',_binary ''),('a7ac43cd-d367-408f-b6fc-ad62a70104ba','User creation or linking','Flow for the existing/non-existing user alternatives','premier','basic-flow',_binary '\0',_binary ''),('b233a524-5b27-4013-9f0d-794550488066','Authentication Options','Authentication options.','premier','basic-flow',_binary '\0',_binary ''),('b6f35d6f-a8a0-4259-be74-becb679b5223','first broker login','Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account','master','basic-flow',_binary '',_binary ''),('b9b41305-4658-4725-b1bf-d05363a7a3d4','docker auth','Used by Docker clients to authenticate against the IDP','premier','basic-flow',_binary '',_binary ''),('bd7f934d-eb27-4f8d-b926-db5e6fa04f5e','Account verification options','Method with which to verity the existing account','premier','basic-flow',_binary '\0',_binary ''),('c0ea5c14-4b11-439d-a91a-24a6bef29b66','registration form','registration form','premier','form-flow',_binary '\0',_binary ''),('ce107784-ca2c-4967-a172-e5e6b793a44a','User creation or linking','Flow for the existing/non-existing user alternatives','master','basic-flow',_binary '\0',_binary ''),('d15d2c19-16e2-4ac4-aceb-d896cf92afc5','clients','Base authentication for clients','premier','client-flow',_binary '',_binary ''),('d7292ba5-cec1-48ca-91a3-bcb47454bdfb','Reset - Conditional OTP','Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.','premier','basic-flow',_binary '\0',_binary ''),('d9a855c9-ee0c-4a7b-a952-640c90516002','registration','registration flow','master','basic-flow',_binary '',_binary ''),('d9d8b731-7bd9-49b4-a6ee-fd8206198747','direct grant','OpenID Connect Resource Owner Grant','master','basic-flow',_binary '',_binary ''),('e7665ab0-dd72-4131-9f58-2e99c5e9a237','docker auth','Used by Docker clients to authenticate against the IDP','master','basic-flow',_binary '',_binary ''),('e84b643f-d1c8-4857-9655-bbf842547294','http challenge','An authentication flow based on challenge-response HTTP Authentication Schemes','master','basic-flow',_binary '',_binary ''),('e988806c-fd6e-426a-8266-475432c98d72','Handle Existing Account','Handle what to do if there is existing account with same email/username like authenticated identity provider','premier','basic-flow',_binary '\0',_binary ''),('ed339ca9-ecdd-4b8c-9b23-f4480cbafa3e','forms','Username, password, otp and other auth forms.','master','basic-flow',_binary '\0',_binary ''),('ee307d34-faf5-45db-926e-dba9fe96e260','reset credentials','Reset credentials for a user if they forgot their password or something','master','basic-flow',_binary '',_binary ''),('ee47c2c7-d606-4654-9b9a-739cdfb2f792','browser','browser based authentication','premier','basic-flow',_binary '',_binary ''),('efc1cf9c-85db-426d-a393-1ecda3c9acf1','clients','Base authentication for clients','master','client-flow',_binary '',_binary ''),('f12288d8-6dba-40e0-9813-ed4cfe926b09','Verify Existing Account by Re-authentication','Reauthentication of existing account','master','basic-flow',_binary '\0',_binary ''),('f3ccf331-d0f2-44f4-843e-476962e6a5ec','Browser - Conditional OTP','Flow to determine if the OTP is required for the authentication','master','basic-flow',_binary '\0',_binary '');
/*!40000 ALTER TABLE `AUTHENTICATION_FLOW` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AUTHENTICATOR_CONFIG`
--

DROP TABLE IF EXISTS `AUTHENTICATOR_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AUTHENTICATOR_CONFIG` (
  `ID` varchar(36) NOT NULL,
  `ALIAS` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_AUTH_CONFIG_REALM` (`REALM_ID`),
  CONSTRAINT `FK_AUTH_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTHENTICATOR_CONFIG`
--

LOCK TABLES `AUTHENTICATOR_CONFIG` WRITE;
/*!40000 ALTER TABLE `AUTHENTICATOR_CONFIG` DISABLE KEYS */;
INSERT INTO `AUTHENTICATOR_CONFIG` VALUES ('182242a9-2b95-4daf-b25a-45301ed83d35','create unique user config','premier'),('33d0271b-749a-4a3e-9be9-85484e866f08','review profile config','master'),('b8a2ff68-6123-4de6-b538-abe3ad58ef44','review profile config','premier'),('f7ad49d1-79d8-48a3-88be-8e683f26b10f','create unique user config','master');
/*!40000 ALTER TABLE `AUTHENTICATOR_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AUTHENTICATOR_CONFIG_ENTRY`
--

DROP TABLE IF EXISTS `AUTHENTICATOR_CONFIG_ENTRY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AUTHENTICATOR_CONFIG_ENTRY` (
  `AUTHENTICATOR_ID` varchar(36) NOT NULL,
  `VALUE` longtext,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`AUTHENTICATOR_ID`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTHENTICATOR_CONFIG_ENTRY`
--

LOCK TABLES `AUTHENTICATOR_CONFIG_ENTRY` WRITE;
/*!40000 ALTER TABLE `AUTHENTICATOR_CONFIG_ENTRY` DISABLE KEYS */;
INSERT INTO `AUTHENTICATOR_CONFIG_ENTRY` VALUES ('182242a9-2b95-4daf-b25a-45301ed83d35','false','require.password.update.after.registration'),('33d0271b-749a-4a3e-9be9-85484e866f08','missing','update.profile.on.first.login'),('b8a2ff68-6123-4de6-b538-abe3ad58ef44','missing','update.profile.on.first.login'),('f7ad49d1-79d8-48a3-88be-8e683f26b10f','false','require.password.update.after.registration');
/*!40000 ALTER TABLE `AUTHENTICATOR_CONFIG_ENTRY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BROKER_LINK`
--

DROP TABLE IF EXISTS `BROKER_LINK`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BROKER_LINK` (
  `IDENTITY_PROVIDER` varchar(255) NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  `BROKER_USER_ID` varchar(255) DEFAULT NULL,
  `BROKER_USERNAME` varchar(255) DEFAULT NULL,
  `TOKEN` text,
  `USER_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`IDENTITY_PROVIDER`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BROKER_LINK`
--

LOCK TABLES `BROKER_LINK` WRITE;
/*!40000 ALTER TABLE `BROKER_LINK` DISABLE KEYS */;
/*!40000 ALTER TABLE `BROKER_LINK` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT`
--

DROP TABLE IF EXISTS `CLIENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT` (
  `ID` varchar(36) NOT NULL,
  `ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `FULL_SCOPE_ALLOWED` bit(1) NOT NULL DEFAULT b'0',
  `CLIENT_ID` varchar(255) DEFAULT NULL,
  `NOT_BEFORE` int DEFAULT NULL,
  `PUBLIC_CLIENT` bit(1) NOT NULL DEFAULT b'0',
  `SECRET` varchar(255) DEFAULT NULL,
  `BASE_URL` varchar(255) DEFAULT NULL,
  `BEARER_ONLY` bit(1) NOT NULL DEFAULT b'0',
  `MANAGEMENT_URL` varchar(255) DEFAULT NULL,
  `SURROGATE_AUTH_REQUIRED` bit(1) NOT NULL DEFAULT b'0',
  `REALM_ID` varchar(36) DEFAULT NULL,
  `PROTOCOL` varchar(255) DEFAULT NULL,
  `NODE_REREG_TIMEOUT` int DEFAULT '0',
  `FRONTCHANNEL_LOGOUT` bit(1) NOT NULL DEFAULT b'0',
  `CONSENT_REQUIRED` bit(1) NOT NULL DEFAULT b'0',
  `NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `SERVICE_ACCOUNTS_ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `CLIENT_AUTHENTICATOR_TYPE` varchar(255) DEFAULT NULL,
  `ROOT_URL` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `REGISTRATION_TOKEN` varchar(255) DEFAULT NULL,
  `STANDARD_FLOW_ENABLED` bit(1) NOT NULL DEFAULT b'1',
  `IMPLICIT_FLOW_ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `DIRECT_ACCESS_GRANTS_ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `ALWAYS_DISPLAY_IN_CONSOLE` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_B71CJLBENV945RB6GCON438AT` (`REALM_ID`,`CLIENT_ID`),
  KEY `IDX_CLIENT_ID` (`CLIENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT`
--

LOCK TABLES `CLIENT` WRITE;
/*!40000 ALTER TABLE `CLIENT` DISABLE KEYS */;
INSERT INTO `CLIENT` VALUES ('05531831-35c0-4a6b-90ba-089c3da089ee',_binary '',_binary '\0','admin-cli',0,_binary '',NULL,NULL,_binary '\0',NULL,_binary '\0','premier','openid-connect',0,_binary '\0',_binary '\0','${client_admin-cli}',_binary '\0','client-secret',NULL,NULL,NULL,_binary '\0',_binary '\0',_binary '',_binary '\0'),('0c682461-637b-4fc9-a380-fb1ea4151528',_binary '',_binary '\0','premier-realm',0,_binary '\0',NULL,NULL,_binary '',NULL,_binary '\0','master',NULL,0,_binary '\0',_binary '\0','premier Realm',_binary '\0','client-secret',NULL,NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0'),('11ffd935-73b8-4ec7-a5ca-676c0b237009',_binary '',_binary '\0','security-admin-console',0,_binary '',NULL,'/admin/master/console/',_binary '\0',NULL,_binary '\0','master','openid-connect',0,_binary '\0',_binary '\0','${client_security-admin-console}',_binary '\0','client-secret','${authAdminUrl}',NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0'),('2daf2562-be27-4374-a8e5-ec3724e075a4',_binary '',_binary '','web-app',0,_binary '',NULL,NULL,_binary '\0','http://localhost:8040/',_binary '\0','premier','openid-connect',-1,_binary '\0',_binary '\0',NULL,_binary '\0','client-secret','http://localhost:8040/',NULL,NULL,_binary '',_binary '\0',_binary '',_binary '\0'),('4759289b-1c4e-4c6c-b89e-376390812801',_binary '',_binary '\0','realm-management',0,_binary '\0',NULL,NULL,_binary '',NULL,_binary '\0','premier','openid-connect',0,_binary '\0',_binary '\0','${client_realm-management}',_binary '\0','client-secret',NULL,NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0'),('73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '',_binary '\0','master-realm',0,_binary '\0',NULL,NULL,_binary '',NULL,_binary '\0','master',NULL,0,_binary '\0',_binary '\0','master Realm',_binary '\0','client-secret',NULL,NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0'),('81532c06-1374-484f-98b7-099a30f05d3b',_binary '',_binary '\0','account',0,_binary '',NULL,'/realms/premier/account/',_binary '\0',NULL,_binary '\0','premier','openid-connect',0,_binary '\0',_binary '\0','${client_account}',_binary '\0','client-secret','${authBaseUrl}',NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0'),('8a8e33ae-dca0-4911-b256-73f48466d04c',_binary '',_binary '\0','broker',0,_binary '\0',NULL,NULL,_binary '',NULL,_binary '\0','master','openid-connect',0,_binary '\0',_binary '\0','${client_broker}',_binary '\0','client-secret',NULL,NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0'),('cad92466-0a1a-4c35-b1fc-54343980c330',_binary '',_binary '\0','account-console',0,_binary '',NULL,'/realms/premier/account/',_binary '\0',NULL,_binary '\0','premier','openid-connect',0,_binary '\0',_binary '\0','${client_account-console}',_binary '\0','client-secret','${authBaseUrl}',NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0'),('caee5346-2b08-4234-aaec-5a548db2fb62',_binary '',_binary '\0','broker',0,_binary '\0',NULL,NULL,_binary '',NULL,_binary '\0','premier','openid-connect',0,_binary '\0',_binary '\0','${client_broker}',_binary '\0','client-secret',NULL,NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0'),('cb82b8af-9a08-4467-930c-6fd317b867ba',_binary '',_binary '\0','security-admin-console',0,_binary '',NULL,'/admin/premier/console/',_binary '\0',NULL,_binary '\0','premier','openid-connect',0,_binary '\0',_binary '\0','${client_security-admin-console}',_binary '\0','client-secret','${authAdminUrl}',NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0'),('d7f22fc8-0d0b-45e9-b3fa-a95bfb0fd81d',_binary '',_binary '\0','admin-cli',0,_binary '',NULL,NULL,_binary '\0',NULL,_binary '\0','master','openid-connect',0,_binary '\0',_binary '\0','${client_admin-cli}',_binary '\0','client-secret',NULL,NULL,NULL,_binary '\0',_binary '\0',_binary '',_binary '\0'),('f2da4c42-aebd-4280-a1b4-96186777b481',_binary '',_binary '\0','account',0,_binary '',NULL,'/realms/master/account/',_binary '\0',NULL,_binary '\0','master','openid-connect',0,_binary '\0',_binary '\0','${client_account}',_binary '\0','client-secret','${authBaseUrl}',NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0'),('fbcb07a8-8e18-4879-a845-6c164ea7452e',_binary '',_binary '\0','account-console',0,_binary '',NULL,'/realms/master/account/',_binary '\0',NULL,_binary '\0','master','openid-connect',0,_binary '\0',_binary '\0','${client_account-console}',_binary '\0','client-secret','${authBaseUrl}',NULL,NULL,_binary '',_binary '\0',_binary '\0',_binary '\0');
/*!40000 ALTER TABLE `CLIENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_ATTRIBUTES`
--

DROP TABLE IF EXISTS `CLIENT_ATTRIBUTES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_ATTRIBUTES` (
  `CLIENT_ID` varchar(36) NOT NULL,
  `VALUE` text,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`NAME`),
  KEY `IDX_CLIENT_ATT_BY_NAME_VALUE` (`NAME`,`VALUE`(255)),
  CONSTRAINT `FK3C47C64BEACCA966` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_ATTRIBUTES`
--

LOCK TABLES `CLIENT_ATTRIBUTES` WRITE;
/*!40000 ALTER TABLE `CLIENT_ATTRIBUTES` DISABLE KEYS */;
INSERT INTO `CLIENT_ATTRIBUTES` VALUES ('11ffd935-73b8-4ec7-a5ca-676c0b237009','S256','pkce.code.challenge.method'),('2daf2562-be27-4374-a8e5-ec3724e075a4','false','backchannel.logout.revoke.offline.tokens'),('2daf2562-be27-4374-a8e5-ec3724e075a4','true','backchannel.logout.session.required'),('cad92466-0a1a-4c35-b1fc-54343980c330','S256','pkce.code.challenge.method'),('cb82b8af-9a08-4467-930c-6fd317b867ba','S256','pkce.code.challenge.method'),('fbcb07a8-8e18-4879-a845-6c164ea7452e','S256','pkce.code.challenge.method');
/*!40000 ALTER TABLE `CLIENT_ATTRIBUTES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_AUTH_FLOW_BINDINGS`
--

DROP TABLE IF EXISTS `CLIENT_AUTH_FLOW_BINDINGS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_AUTH_FLOW_BINDINGS` (
  `CLIENT_ID` varchar(36) NOT NULL,
  `FLOW_ID` varchar(36) DEFAULT NULL,
  `BINDING_NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`BINDING_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_AUTH_FLOW_BINDINGS`
--

LOCK TABLES `CLIENT_AUTH_FLOW_BINDINGS` WRITE;
/*!40000 ALTER TABLE `CLIENT_AUTH_FLOW_BINDINGS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_AUTH_FLOW_BINDINGS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_INITIAL_ACCESS`
--

DROP TABLE IF EXISTS `CLIENT_INITIAL_ACCESS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_INITIAL_ACCESS` (
  `ID` varchar(36) NOT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  `TIMESTAMP` int DEFAULT NULL,
  `EXPIRATION` int DEFAULT NULL,
  `COUNT` int DEFAULT NULL,
  `REMAINING_COUNT` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_CLIENT_INIT_ACC_REALM` (`REALM_ID`),
  CONSTRAINT `FK_CLIENT_INIT_ACC_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_INITIAL_ACCESS`
--

LOCK TABLES `CLIENT_INITIAL_ACCESS` WRITE;
/*!40000 ALTER TABLE `CLIENT_INITIAL_ACCESS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_INITIAL_ACCESS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_NODE_REGISTRATIONS`
--

DROP TABLE IF EXISTS `CLIENT_NODE_REGISTRATIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_NODE_REGISTRATIONS` (
  `CLIENT_ID` varchar(36) NOT NULL,
  `VALUE` int DEFAULT NULL,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`NAME`),
  CONSTRAINT `FK4129723BA992F594` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_NODE_REGISTRATIONS`
--

LOCK TABLES `CLIENT_NODE_REGISTRATIONS` WRITE;
/*!40000 ALTER TABLE `CLIENT_NODE_REGISTRATIONS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_NODE_REGISTRATIONS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SCOPE`
--

DROP TABLE IF EXISTS `CLIENT_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SCOPE` (
  `ID` varchar(36) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(36) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `PROTOCOL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_CLI_SCOPE` (`REALM_ID`,`NAME`),
  KEY `IDX_REALM_CLSCOPE` (`REALM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SCOPE`
--

LOCK TABLES `CLIENT_SCOPE` WRITE;
/*!40000 ALTER TABLE `CLIENT_SCOPE` DISABLE KEYS */;
INSERT INTO `CLIENT_SCOPE` VALUES ('1b8b705a-46a0-401a-b3fe-5bdc0f8bed62','role_list','premier','SAML role list','saml'),('260bb8f9-c0c3-43a5-acf4-07c78bd3fca7','profile','premier','OpenID Connect built-in scope: profile','openid-connect'),('3de019da-3ffd-4a07-9cdb-8ad42a185ea2','roles','premier','OpenID Connect scope for add user roles to the access token','openid-connect'),('45738afe-75d9-4d0f-a13c-6e5a4c879648','offline_access','premier','OpenID Connect built-in scope: offline_access','openid-connect'),('46a22422-7357-44f2-b7a2-c09757855ada','email','master','OpenID Connect built-in scope: email','openid-connect'),('4ca73df8-9b1b-4095-933e-a725d4abf31a','microprofile-jwt','master','Microprofile - JWT built-in scope','openid-connect'),('59680041-0490-428f-a752-fa7af29388bb','address','premier','OpenID Connect built-in scope: address','openid-connect'),('73a2d837-3a42-4133-908e-ca54e2f29677','profile','master','OpenID Connect built-in scope: profile','openid-connect'),('8ad5ab9f-7492-4752-bac7-8ff177e1d54e','email','premier','OpenID Connect built-in scope: email','openid-connect'),('8f98f9e9-29c7-4353-8944-1efc25c0ee38','address','master','OpenID Connect built-in scope: address','openid-connect'),('95d5c0ad-2f1e-4352-82f9-413423c761b6','web-origins','master','OpenID Connect scope for add allowed web origins to the access token','openid-connect'),('9db15b72-b3ed-45b9-bb2e-eacb41208941','microprofile-jwt','premier','Microprofile - JWT built-in scope','openid-connect'),('ba614954-79b7-424b-a619-8a1f3bac41ba','roles','master','OpenID Connect scope for add user roles to the access token','openid-connect'),('cc333c37-309e-4b46-b1be-b61953eb5180','role_list','master','SAML role list','saml'),('d0fd93f7-9c0c-47d5-b15b-e6528c90a942','phone','premier','OpenID Connect built-in scope: phone','openid-connect'),('e9106541-1d67-42b4-95c7-04c07d06c903','phone','master','OpenID Connect built-in scope: phone','openid-connect'),('f9556e3c-e301-443c-8b68-f59b54f716ef','offline_access','master','OpenID Connect built-in scope: offline_access','openid-connect'),('fa0593b6-5702-4790-b2b2-3b78c1bf4c5f','web-origins','premier','OpenID Connect scope for add allowed web origins to the access token','openid-connect');
/*!40000 ALTER TABLE `CLIENT_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SCOPE_ATTRIBUTES`
--

DROP TABLE IF EXISTS `CLIENT_SCOPE_ATTRIBUTES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SCOPE_ATTRIBUTES` (
  `SCOPE_ID` varchar(36) NOT NULL,
  `VALUE` text,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`SCOPE_ID`,`NAME`),
  KEY `IDX_CLSCOPE_ATTRS` (`SCOPE_ID`),
  CONSTRAINT `FK_CL_SCOPE_ATTR_SCOPE` FOREIGN KEY (`SCOPE_ID`) REFERENCES `CLIENT_SCOPE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SCOPE_ATTRIBUTES`
--

LOCK TABLES `CLIENT_SCOPE_ATTRIBUTES` WRITE;
/*!40000 ALTER TABLE `CLIENT_SCOPE_ATTRIBUTES` DISABLE KEYS */;
INSERT INTO `CLIENT_SCOPE_ATTRIBUTES` VALUES ('1b8b705a-46a0-401a-b3fe-5bdc0f8bed62','${samlRoleListScopeConsentText}','consent.screen.text'),('1b8b705a-46a0-401a-b3fe-5bdc0f8bed62','true','display.on.consent.screen'),('260bb8f9-c0c3-43a5-acf4-07c78bd3fca7','${profileScopeConsentText}','consent.screen.text'),('260bb8f9-c0c3-43a5-acf4-07c78bd3fca7','true','display.on.consent.screen'),('260bb8f9-c0c3-43a5-acf4-07c78bd3fca7','true','include.in.token.scope'),('3de019da-3ffd-4a07-9cdb-8ad42a185ea2','${rolesScopeConsentText}','consent.screen.text'),('3de019da-3ffd-4a07-9cdb-8ad42a185ea2','true','display.on.consent.screen'),('3de019da-3ffd-4a07-9cdb-8ad42a185ea2','false','include.in.token.scope'),('45738afe-75d9-4d0f-a13c-6e5a4c879648','${offlineAccessScopeConsentText}','consent.screen.text'),('45738afe-75d9-4d0f-a13c-6e5a4c879648','true','display.on.consent.screen'),('46a22422-7357-44f2-b7a2-c09757855ada','${emailScopeConsentText}','consent.screen.text'),('46a22422-7357-44f2-b7a2-c09757855ada','true','display.on.consent.screen'),('46a22422-7357-44f2-b7a2-c09757855ada','true','include.in.token.scope'),('4ca73df8-9b1b-4095-933e-a725d4abf31a','false','display.on.consent.screen'),('4ca73df8-9b1b-4095-933e-a725d4abf31a','true','include.in.token.scope'),('59680041-0490-428f-a752-fa7af29388bb','${addressScopeConsentText}','consent.screen.text'),('59680041-0490-428f-a752-fa7af29388bb','true','display.on.consent.screen'),('59680041-0490-428f-a752-fa7af29388bb','true','include.in.token.scope'),('73a2d837-3a42-4133-908e-ca54e2f29677','${profileScopeConsentText}','consent.screen.text'),('73a2d837-3a42-4133-908e-ca54e2f29677','true','display.on.consent.screen'),('73a2d837-3a42-4133-908e-ca54e2f29677','true','include.in.token.scope'),('8ad5ab9f-7492-4752-bac7-8ff177e1d54e','${emailScopeConsentText}','consent.screen.text'),('8ad5ab9f-7492-4752-bac7-8ff177e1d54e','true','display.on.consent.screen'),('8ad5ab9f-7492-4752-bac7-8ff177e1d54e','true','include.in.token.scope'),('8f98f9e9-29c7-4353-8944-1efc25c0ee38','${addressScopeConsentText}','consent.screen.text'),('8f98f9e9-29c7-4353-8944-1efc25c0ee38','true','display.on.consent.screen'),('8f98f9e9-29c7-4353-8944-1efc25c0ee38','true','include.in.token.scope'),('95d5c0ad-2f1e-4352-82f9-413423c761b6','','consent.screen.text'),('95d5c0ad-2f1e-4352-82f9-413423c761b6','false','display.on.consent.screen'),('95d5c0ad-2f1e-4352-82f9-413423c761b6','false','include.in.token.scope'),('9db15b72-b3ed-45b9-bb2e-eacb41208941','false','display.on.consent.screen'),('9db15b72-b3ed-45b9-bb2e-eacb41208941','true','include.in.token.scope'),('ba614954-79b7-424b-a619-8a1f3bac41ba','${rolesScopeConsentText}','consent.screen.text'),('ba614954-79b7-424b-a619-8a1f3bac41ba','true','display.on.consent.screen'),('ba614954-79b7-424b-a619-8a1f3bac41ba','false','include.in.token.scope'),('cc333c37-309e-4b46-b1be-b61953eb5180','${samlRoleListScopeConsentText}','consent.screen.text'),('cc333c37-309e-4b46-b1be-b61953eb5180','true','display.on.consent.screen'),('d0fd93f7-9c0c-47d5-b15b-e6528c90a942','${phoneScopeConsentText}','consent.screen.text'),('d0fd93f7-9c0c-47d5-b15b-e6528c90a942','true','display.on.consent.screen'),('d0fd93f7-9c0c-47d5-b15b-e6528c90a942','true','include.in.token.scope'),('e9106541-1d67-42b4-95c7-04c07d06c903','${phoneScopeConsentText}','consent.screen.text'),('e9106541-1d67-42b4-95c7-04c07d06c903','true','display.on.consent.screen'),('e9106541-1d67-42b4-95c7-04c07d06c903','true','include.in.token.scope'),('f9556e3c-e301-443c-8b68-f59b54f716ef','${offlineAccessScopeConsentText}','consent.screen.text'),('f9556e3c-e301-443c-8b68-f59b54f716ef','true','display.on.consent.screen'),('fa0593b6-5702-4790-b2b2-3b78c1bf4c5f','','consent.screen.text'),('fa0593b6-5702-4790-b2b2-3b78c1bf4c5f','false','display.on.consent.screen'),('fa0593b6-5702-4790-b2b2-3b78c1bf4c5f','false','include.in.token.scope');
/*!40000 ALTER TABLE `CLIENT_SCOPE_ATTRIBUTES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SCOPE_CLIENT`
--

DROP TABLE IF EXISTS `CLIENT_SCOPE_CLIENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SCOPE_CLIENT` (
  `CLIENT_ID` varchar(255) NOT NULL,
  `SCOPE_ID` varchar(255) NOT NULL,
  `DEFAULT_SCOPE` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`CLIENT_ID`,`SCOPE_ID`),
  KEY `IDX_CLSCOPE_CL` (`CLIENT_ID`),
  KEY `IDX_CL_CLSCOPE` (`SCOPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SCOPE_CLIENT`
--

LOCK TABLES `CLIENT_SCOPE_CLIENT` WRITE;
/*!40000 ALTER TABLE `CLIENT_SCOPE_CLIENT` DISABLE KEYS */;
INSERT INTO `CLIENT_SCOPE_CLIENT` VALUES ('05531831-35c0-4a6b-90ba-089c3da089ee','260bb8f9-c0c3-43a5-acf4-07c78bd3fca7',_binary ''),('05531831-35c0-4a6b-90ba-089c3da089ee','3de019da-3ffd-4a07-9cdb-8ad42a185ea2',_binary ''),('05531831-35c0-4a6b-90ba-089c3da089ee','45738afe-75d9-4d0f-a13c-6e5a4c879648',_binary '\0'),('05531831-35c0-4a6b-90ba-089c3da089ee','59680041-0490-428f-a752-fa7af29388bb',_binary '\0'),('05531831-35c0-4a6b-90ba-089c3da089ee','8ad5ab9f-7492-4752-bac7-8ff177e1d54e',_binary ''),('05531831-35c0-4a6b-90ba-089c3da089ee','9db15b72-b3ed-45b9-bb2e-eacb41208941',_binary '\0'),('05531831-35c0-4a6b-90ba-089c3da089ee','d0fd93f7-9c0c-47d5-b15b-e6528c90a942',_binary '\0'),('05531831-35c0-4a6b-90ba-089c3da089ee','fa0593b6-5702-4790-b2b2-3b78c1bf4c5f',_binary ''),('11ffd935-73b8-4ec7-a5ca-676c0b237009','46a22422-7357-44f2-b7a2-c09757855ada',_binary ''),('11ffd935-73b8-4ec7-a5ca-676c0b237009','4ca73df8-9b1b-4095-933e-a725d4abf31a',_binary '\0'),('11ffd935-73b8-4ec7-a5ca-676c0b237009','73a2d837-3a42-4133-908e-ca54e2f29677',_binary ''),('11ffd935-73b8-4ec7-a5ca-676c0b237009','8f98f9e9-29c7-4353-8944-1efc25c0ee38',_binary '\0'),('11ffd935-73b8-4ec7-a5ca-676c0b237009','95d5c0ad-2f1e-4352-82f9-413423c761b6',_binary ''),('11ffd935-73b8-4ec7-a5ca-676c0b237009','ba614954-79b7-424b-a619-8a1f3bac41ba',_binary ''),('11ffd935-73b8-4ec7-a5ca-676c0b237009','e9106541-1d67-42b4-95c7-04c07d06c903',_binary '\0'),('11ffd935-73b8-4ec7-a5ca-676c0b237009','f9556e3c-e301-443c-8b68-f59b54f716ef',_binary '\0'),('2daf2562-be27-4374-a8e5-ec3724e075a4','260bb8f9-c0c3-43a5-acf4-07c78bd3fca7',_binary ''),('2daf2562-be27-4374-a8e5-ec3724e075a4','3de019da-3ffd-4a07-9cdb-8ad42a185ea2',_binary ''),('2daf2562-be27-4374-a8e5-ec3724e075a4','45738afe-75d9-4d0f-a13c-6e5a4c879648',_binary '\0'),('2daf2562-be27-4374-a8e5-ec3724e075a4','59680041-0490-428f-a752-fa7af29388bb',_binary '\0'),('2daf2562-be27-4374-a8e5-ec3724e075a4','8ad5ab9f-7492-4752-bac7-8ff177e1d54e',_binary ''),('2daf2562-be27-4374-a8e5-ec3724e075a4','9db15b72-b3ed-45b9-bb2e-eacb41208941',_binary '\0'),('2daf2562-be27-4374-a8e5-ec3724e075a4','d0fd93f7-9c0c-47d5-b15b-e6528c90a942',_binary '\0'),('2daf2562-be27-4374-a8e5-ec3724e075a4','fa0593b6-5702-4790-b2b2-3b78c1bf4c5f',_binary ''),('4759289b-1c4e-4c6c-b89e-376390812801','260bb8f9-c0c3-43a5-acf4-07c78bd3fca7',_binary ''),('4759289b-1c4e-4c6c-b89e-376390812801','3de019da-3ffd-4a07-9cdb-8ad42a185ea2',_binary ''),('4759289b-1c4e-4c6c-b89e-376390812801','45738afe-75d9-4d0f-a13c-6e5a4c879648',_binary '\0'),('4759289b-1c4e-4c6c-b89e-376390812801','59680041-0490-428f-a752-fa7af29388bb',_binary '\0'),('4759289b-1c4e-4c6c-b89e-376390812801','8ad5ab9f-7492-4752-bac7-8ff177e1d54e',_binary ''),('4759289b-1c4e-4c6c-b89e-376390812801','9db15b72-b3ed-45b9-bb2e-eacb41208941',_binary '\0'),('4759289b-1c4e-4c6c-b89e-376390812801','d0fd93f7-9c0c-47d5-b15b-e6528c90a942',_binary '\0'),('4759289b-1c4e-4c6c-b89e-376390812801','fa0593b6-5702-4790-b2b2-3b78c1bf4c5f',_binary ''),('73dcb78f-3531-43f9-8a08-d1a50ba33a95','46a22422-7357-44f2-b7a2-c09757855ada',_binary ''),('73dcb78f-3531-43f9-8a08-d1a50ba33a95','4ca73df8-9b1b-4095-933e-a725d4abf31a',_binary '\0'),('73dcb78f-3531-43f9-8a08-d1a50ba33a95','73a2d837-3a42-4133-908e-ca54e2f29677',_binary ''),('73dcb78f-3531-43f9-8a08-d1a50ba33a95','8f98f9e9-29c7-4353-8944-1efc25c0ee38',_binary '\0'),('73dcb78f-3531-43f9-8a08-d1a50ba33a95','95d5c0ad-2f1e-4352-82f9-413423c761b6',_binary ''),('73dcb78f-3531-43f9-8a08-d1a50ba33a95','ba614954-79b7-424b-a619-8a1f3bac41ba',_binary ''),('73dcb78f-3531-43f9-8a08-d1a50ba33a95','e9106541-1d67-42b4-95c7-04c07d06c903',_binary '\0'),('73dcb78f-3531-43f9-8a08-d1a50ba33a95','f9556e3c-e301-443c-8b68-f59b54f716ef',_binary '\0'),('81532c06-1374-484f-98b7-099a30f05d3b','260bb8f9-c0c3-43a5-acf4-07c78bd3fca7',_binary ''),('81532c06-1374-484f-98b7-099a30f05d3b','3de019da-3ffd-4a07-9cdb-8ad42a185ea2',_binary ''),('81532c06-1374-484f-98b7-099a30f05d3b','45738afe-75d9-4d0f-a13c-6e5a4c879648',_binary '\0'),('81532c06-1374-484f-98b7-099a30f05d3b','59680041-0490-428f-a752-fa7af29388bb',_binary '\0'),('81532c06-1374-484f-98b7-099a30f05d3b','8ad5ab9f-7492-4752-bac7-8ff177e1d54e',_binary ''),('81532c06-1374-484f-98b7-099a30f05d3b','9db15b72-b3ed-45b9-bb2e-eacb41208941',_binary '\0'),('81532c06-1374-484f-98b7-099a30f05d3b','d0fd93f7-9c0c-47d5-b15b-e6528c90a942',_binary '\0'),('81532c06-1374-484f-98b7-099a30f05d3b','fa0593b6-5702-4790-b2b2-3b78c1bf4c5f',_binary ''),('8a8e33ae-dca0-4911-b256-73f48466d04c','46a22422-7357-44f2-b7a2-c09757855ada',_binary ''),('8a8e33ae-dca0-4911-b256-73f48466d04c','4ca73df8-9b1b-4095-933e-a725d4abf31a',_binary '\0'),('8a8e33ae-dca0-4911-b256-73f48466d04c','73a2d837-3a42-4133-908e-ca54e2f29677',_binary ''),('8a8e33ae-dca0-4911-b256-73f48466d04c','8f98f9e9-29c7-4353-8944-1efc25c0ee38',_binary '\0'),('8a8e33ae-dca0-4911-b256-73f48466d04c','95d5c0ad-2f1e-4352-82f9-413423c761b6',_binary ''),('8a8e33ae-dca0-4911-b256-73f48466d04c','ba614954-79b7-424b-a619-8a1f3bac41ba',_binary ''),('8a8e33ae-dca0-4911-b256-73f48466d04c','e9106541-1d67-42b4-95c7-04c07d06c903',_binary '\0'),('8a8e33ae-dca0-4911-b256-73f48466d04c','f9556e3c-e301-443c-8b68-f59b54f716ef',_binary '\0'),('cad92466-0a1a-4c35-b1fc-54343980c330','260bb8f9-c0c3-43a5-acf4-07c78bd3fca7',_binary ''),('cad92466-0a1a-4c35-b1fc-54343980c330','3de019da-3ffd-4a07-9cdb-8ad42a185ea2',_binary ''),('cad92466-0a1a-4c35-b1fc-54343980c330','45738afe-75d9-4d0f-a13c-6e5a4c879648',_binary '\0'),('cad92466-0a1a-4c35-b1fc-54343980c330','59680041-0490-428f-a752-fa7af29388bb',_binary '\0'),('cad92466-0a1a-4c35-b1fc-54343980c330','8ad5ab9f-7492-4752-bac7-8ff177e1d54e',_binary ''),('cad92466-0a1a-4c35-b1fc-54343980c330','9db15b72-b3ed-45b9-bb2e-eacb41208941',_binary '\0'),('cad92466-0a1a-4c35-b1fc-54343980c330','d0fd93f7-9c0c-47d5-b15b-e6528c90a942',_binary '\0'),('cad92466-0a1a-4c35-b1fc-54343980c330','fa0593b6-5702-4790-b2b2-3b78c1bf4c5f',_binary ''),('caee5346-2b08-4234-aaec-5a548db2fb62','260bb8f9-c0c3-43a5-acf4-07c78bd3fca7',_binary ''),('caee5346-2b08-4234-aaec-5a548db2fb62','3de019da-3ffd-4a07-9cdb-8ad42a185ea2',_binary ''),('caee5346-2b08-4234-aaec-5a548db2fb62','45738afe-75d9-4d0f-a13c-6e5a4c879648',_binary '\0'),('caee5346-2b08-4234-aaec-5a548db2fb62','59680041-0490-428f-a752-fa7af29388bb',_binary '\0'),('caee5346-2b08-4234-aaec-5a548db2fb62','8ad5ab9f-7492-4752-bac7-8ff177e1d54e',_binary ''),('caee5346-2b08-4234-aaec-5a548db2fb62','9db15b72-b3ed-45b9-bb2e-eacb41208941',_binary '\0'),('caee5346-2b08-4234-aaec-5a548db2fb62','d0fd93f7-9c0c-47d5-b15b-e6528c90a942',_binary '\0'),('caee5346-2b08-4234-aaec-5a548db2fb62','fa0593b6-5702-4790-b2b2-3b78c1bf4c5f',_binary ''),('cb82b8af-9a08-4467-930c-6fd317b867ba','260bb8f9-c0c3-43a5-acf4-07c78bd3fca7',_binary ''),('cb82b8af-9a08-4467-930c-6fd317b867ba','3de019da-3ffd-4a07-9cdb-8ad42a185ea2',_binary ''),('cb82b8af-9a08-4467-930c-6fd317b867ba','45738afe-75d9-4d0f-a13c-6e5a4c879648',_binary '\0'),('cb82b8af-9a08-4467-930c-6fd317b867ba','59680041-0490-428f-a752-fa7af29388bb',_binary '\0'),('cb82b8af-9a08-4467-930c-6fd317b867ba','8ad5ab9f-7492-4752-bac7-8ff177e1d54e',_binary ''),('cb82b8af-9a08-4467-930c-6fd317b867ba','9db15b72-b3ed-45b9-bb2e-eacb41208941',_binary '\0'),('cb82b8af-9a08-4467-930c-6fd317b867ba','d0fd93f7-9c0c-47d5-b15b-e6528c90a942',_binary '\0'),('cb82b8af-9a08-4467-930c-6fd317b867ba','fa0593b6-5702-4790-b2b2-3b78c1bf4c5f',_binary ''),('d7f22fc8-0d0b-45e9-b3fa-a95bfb0fd81d','46a22422-7357-44f2-b7a2-c09757855ada',_binary ''),('d7f22fc8-0d0b-45e9-b3fa-a95bfb0fd81d','4ca73df8-9b1b-4095-933e-a725d4abf31a',_binary '\0'),('d7f22fc8-0d0b-45e9-b3fa-a95bfb0fd81d','73a2d837-3a42-4133-908e-ca54e2f29677',_binary ''),('d7f22fc8-0d0b-45e9-b3fa-a95bfb0fd81d','8f98f9e9-29c7-4353-8944-1efc25c0ee38',_binary '\0'),('d7f22fc8-0d0b-45e9-b3fa-a95bfb0fd81d','95d5c0ad-2f1e-4352-82f9-413423c761b6',_binary ''),('d7f22fc8-0d0b-45e9-b3fa-a95bfb0fd81d','ba614954-79b7-424b-a619-8a1f3bac41ba',_binary ''),('d7f22fc8-0d0b-45e9-b3fa-a95bfb0fd81d','e9106541-1d67-42b4-95c7-04c07d06c903',_binary '\0'),('d7f22fc8-0d0b-45e9-b3fa-a95bfb0fd81d','f9556e3c-e301-443c-8b68-f59b54f716ef',_binary '\0'),('f2da4c42-aebd-4280-a1b4-96186777b481','46a22422-7357-44f2-b7a2-c09757855ada',_binary ''),('f2da4c42-aebd-4280-a1b4-96186777b481','4ca73df8-9b1b-4095-933e-a725d4abf31a',_binary '\0'),('f2da4c42-aebd-4280-a1b4-96186777b481','73a2d837-3a42-4133-908e-ca54e2f29677',_binary ''),('f2da4c42-aebd-4280-a1b4-96186777b481','8f98f9e9-29c7-4353-8944-1efc25c0ee38',_binary '\0'),('f2da4c42-aebd-4280-a1b4-96186777b481','95d5c0ad-2f1e-4352-82f9-413423c761b6',_binary ''),('f2da4c42-aebd-4280-a1b4-96186777b481','ba614954-79b7-424b-a619-8a1f3bac41ba',_binary ''),('f2da4c42-aebd-4280-a1b4-96186777b481','e9106541-1d67-42b4-95c7-04c07d06c903',_binary '\0'),('f2da4c42-aebd-4280-a1b4-96186777b481','f9556e3c-e301-443c-8b68-f59b54f716ef',_binary '\0'),('fbcb07a8-8e18-4879-a845-6c164ea7452e','46a22422-7357-44f2-b7a2-c09757855ada',_binary ''),('fbcb07a8-8e18-4879-a845-6c164ea7452e','4ca73df8-9b1b-4095-933e-a725d4abf31a',_binary '\0'),('fbcb07a8-8e18-4879-a845-6c164ea7452e','73a2d837-3a42-4133-908e-ca54e2f29677',_binary ''),('fbcb07a8-8e18-4879-a845-6c164ea7452e','8f98f9e9-29c7-4353-8944-1efc25c0ee38',_binary '\0'),('fbcb07a8-8e18-4879-a845-6c164ea7452e','95d5c0ad-2f1e-4352-82f9-413423c761b6',_binary ''),('fbcb07a8-8e18-4879-a845-6c164ea7452e','ba614954-79b7-424b-a619-8a1f3bac41ba',_binary ''),('fbcb07a8-8e18-4879-a845-6c164ea7452e','e9106541-1d67-42b4-95c7-04c07d06c903',_binary '\0'),('fbcb07a8-8e18-4879-a845-6c164ea7452e','f9556e3c-e301-443c-8b68-f59b54f716ef',_binary '\0');
/*!40000 ALTER TABLE `CLIENT_SCOPE_CLIENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SCOPE_ROLE_MAPPING`
--

DROP TABLE IF EXISTS `CLIENT_SCOPE_ROLE_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SCOPE_ROLE_MAPPING` (
  `SCOPE_ID` varchar(36) NOT NULL,
  `ROLE_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`SCOPE_ID`,`ROLE_ID`),
  KEY `IDX_CLSCOPE_ROLE` (`SCOPE_ID`),
  KEY `IDX_ROLE_CLSCOPE` (`ROLE_ID`),
  CONSTRAINT `FK_CL_SCOPE_RM_SCOPE` FOREIGN KEY (`SCOPE_ID`) REFERENCES `CLIENT_SCOPE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SCOPE_ROLE_MAPPING`
--

LOCK TABLES `CLIENT_SCOPE_ROLE_MAPPING` WRITE;
/*!40000 ALTER TABLE `CLIENT_SCOPE_ROLE_MAPPING` DISABLE KEYS */;
INSERT INTO `CLIENT_SCOPE_ROLE_MAPPING` VALUES ('45738afe-75d9-4d0f-a13c-6e5a4c879648','b526cd2a-450d-48a6-b3f7-62d52498a3fe'),('f9556e3c-e301-443c-8b68-f59b54f716ef','79050af3-eea9-4d0b-886f-40f2bfad293d');
/*!40000 ALTER TABLE `CLIENT_SCOPE_ROLE_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SESSION`
--

DROP TABLE IF EXISTS `CLIENT_SESSION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SESSION` (
  `ID` varchar(36) NOT NULL,
  `CLIENT_ID` varchar(36) DEFAULT NULL,
  `REDIRECT_URI` varchar(255) DEFAULT NULL,
  `STATE` varchar(255) DEFAULT NULL,
  `TIMESTAMP` int DEFAULT NULL,
  `SESSION_ID` varchar(36) DEFAULT NULL,
  `AUTH_METHOD` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(255) DEFAULT NULL,
  `AUTH_USER_ID` varchar(36) DEFAULT NULL,
  `CURRENT_ACTION` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_CLIENT_SESSION_SESSION` (`SESSION_ID`),
  CONSTRAINT `FK_B4AO2VCVAT6UKAU74WBWTFQO1` FOREIGN KEY (`SESSION_ID`) REFERENCES `USER_SESSION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SESSION`
--

LOCK TABLES `CLIENT_SESSION` WRITE;
/*!40000 ALTER TABLE `CLIENT_SESSION` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_SESSION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SESSION_AUTH_STATUS`
--

DROP TABLE IF EXISTS `CLIENT_SESSION_AUTH_STATUS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SESSION_AUTH_STATUS` (
  `AUTHENTICATOR` varchar(36) NOT NULL,
  `STATUS` int DEFAULT NULL,
  `CLIENT_SESSION` varchar(36) NOT NULL,
  PRIMARY KEY (`CLIENT_SESSION`,`AUTHENTICATOR`),
  CONSTRAINT `AUTH_STATUS_CONSTRAINT` FOREIGN KEY (`CLIENT_SESSION`) REFERENCES `CLIENT_SESSION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SESSION_AUTH_STATUS`
--

LOCK TABLES `CLIENT_SESSION_AUTH_STATUS` WRITE;
/*!40000 ALTER TABLE `CLIENT_SESSION_AUTH_STATUS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_SESSION_AUTH_STATUS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SESSION_NOTE`
--

DROP TABLE IF EXISTS `CLIENT_SESSION_NOTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SESSION_NOTE` (
  `NAME` varchar(255) NOT NULL,
  `VALUE` varchar(255) DEFAULT NULL,
  `CLIENT_SESSION` varchar(36) NOT NULL,
  PRIMARY KEY (`CLIENT_SESSION`,`NAME`),
  CONSTRAINT `FK5EDFB00FF51C2736` FOREIGN KEY (`CLIENT_SESSION`) REFERENCES `CLIENT_SESSION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SESSION_NOTE`
--

LOCK TABLES `CLIENT_SESSION_NOTE` WRITE;
/*!40000 ALTER TABLE `CLIENT_SESSION_NOTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_SESSION_NOTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SESSION_PROT_MAPPER`
--

DROP TABLE IF EXISTS `CLIENT_SESSION_PROT_MAPPER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SESSION_PROT_MAPPER` (
  `PROTOCOL_MAPPER_ID` varchar(36) NOT NULL,
  `CLIENT_SESSION` varchar(36) NOT NULL,
  PRIMARY KEY (`CLIENT_SESSION`,`PROTOCOL_MAPPER_ID`),
  CONSTRAINT `FK_33A8SGQW18I532811V7O2DK89` FOREIGN KEY (`CLIENT_SESSION`) REFERENCES `CLIENT_SESSION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SESSION_PROT_MAPPER`
--

LOCK TABLES `CLIENT_SESSION_PROT_MAPPER` WRITE;
/*!40000 ALTER TABLE `CLIENT_SESSION_PROT_MAPPER` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_SESSION_PROT_MAPPER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_SESSION_ROLE`
--

DROP TABLE IF EXISTS `CLIENT_SESSION_ROLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_SESSION_ROLE` (
  `ROLE_ID` varchar(255) NOT NULL,
  `CLIENT_SESSION` varchar(36) NOT NULL,
  PRIMARY KEY (`CLIENT_SESSION`,`ROLE_ID`),
  CONSTRAINT `FK_11B7SGQW18I532811V7O2DV76` FOREIGN KEY (`CLIENT_SESSION`) REFERENCES `CLIENT_SESSION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_SESSION_ROLE`
--

LOCK TABLES `CLIENT_SESSION_ROLE` WRITE;
/*!40000 ALTER TABLE `CLIENT_SESSION_ROLE` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_SESSION_ROLE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENT_USER_SESSION_NOTE`
--

DROP TABLE IF EXISTS `CLIENT_USER_SESSION_NOTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENT_USER_SESSION_NOTE` (
  `NAME` varchar(255) NOT NULL,
  `VALUE` text,
  `CLIENT_SESSION` varchar(36) NOT NULL,
  PRIMARY KEY (`CLIENT_SESSION`,`NAME`),
  CONSTRAINT `FK_CL_USR_SES_NOTE` FOREIGN KEY (`CLIENT_SESSION`) REFERENCES `CLIENT_SESSION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENT_USER_SESSION_NOTE`
--

LOCK TABLES `CLIENT_USER_SESSION_NOTE` WRITE;
/*!40000 ALTER TABLE `CLIENT_USER_SESSION_NOTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENT_USER_SESSION_NOTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COMPONENT`
--

DROP TABLE IF EXISTS `COMPONENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COMPONENT` (
  `ID` varchar(36) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `PARENT_ID` varchar(36) DEFAULT NULL,
  `PROVIDER_ID` varchar(36) DEFAULT NULL,
  `PROVIDER_TYPE` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(36) DEFAULT NULL,
  `SUB_TYPE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_COMPONENT_REALM` (`REALM_ID`),
  KEY `IDX_COMPONENT_PROVIDER_TYPE` (`PROVIDER_TYPE`),
  CONSTRAINT `FK_COMPONENT_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMPONENT`
--

LOCK TABLES `COMPONENT` WRITE;
/*!40000 ALTER TABLE `COMPONENT` DISABLE KEYS */;
INSERT INTO `COMPONENT` VALUES ('150a45c0-0656-4d2e-a5d1-7f20cffd0e8b','Allowed Protocol Mapper Types','premier','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','premier','authenticated'),('154b20af-4a9a-419e-b08f-c1bd78b7f4aa','Consent Required','master','consent-required','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','master','anonymous'),('1af41a6a-4526-490e-b2b8-0b125cd543f4','rsa-generated','premier','rsa-generated','org.keycloak.keys.KeyProvider','premier',NULL),('29301511-92ae-40f6-a3c4-be186021b316','rsa-enc-generated','premier','rsa-enc-generated','org.keycloak.keys.KeyProvider','premier',NULL),('2b0f8443-2061-4ffc-b7ec-7ee0e67da92d','Max Clients Limit','master','max-clients','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','master','anonymous'),('35a98ab3-f35a-4054-ab46-d91e61439500','Trusted Hosts','master','trusted-hosts','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','master','anonymous'),('35e83b8d-6c8c-400e-83aa-2bd2058703f4','Allowed Client Scopes','master','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','master','authenticated'),('42a01ae3-e184-4a50-aefa-6a0123366b88','Allowed Client Scopes','premier','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','premier','authenticated'),('46632e05-7cc8-4751-a761-71232d35eb1c','Allowed Client Scopes','master','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','master','anonymous'),('51cfac42-e42a-4157-8385-e2bb9c9437bd','Allowed Client Scopes','premier','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','premier','anonymous'),('66546c43-7aac-4493-80ec-6984d6a8326e','rsa-enc-generated','master','rsa-enc-generated','org.keycloak.keys.KeyProvider','master',NULL),('67cc6241-9cd0-404d-82af-e9eec3f02f92','Full Scope Disabled','premier','scope','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','premier','anonymous'),('76aff126-1583-4b50-912e-ac99a4910fca','Trusted Hosts','premier','trusted-hosts','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','premier','anonymous'),('83d895b2-4b93-42b6-880f-16acf0d75f0a','Full Scope Disabled','master','scope','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','master','anonymous'),('846362d6-e5f4-47ab-b19c-2595cac28c4c','aes-generated','master','aes-generated','org.keycloak.keys.KeyProvider','master',NULL),('97bc7385-e87d-43d8-ad0c-0ac94f0d473f','Consent Required','premier','consent-required','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','premier','anonymous'),('9ac1fe82-f674-4ade-ba86-b7d660658a1c','Allowed Protocol Mapper Types','master','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','master','authenticated'),('c52a38d9-cbd7-40e7-91ed-cafcbf06e951','hmac-generated','master','hmac-generated','org.keycloak.keys.KeyProvider','master',NULL),('c64d23dd-0167-42eb-a37f-519fb2b77447','Allowed Protocol Mapper Types','premier','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','premier','anonymous'),('c92edf6b-8bf5-4c64-8b49-d508a1f9d749','rsa-generated','master','rsa-generated','org.keycloak.keys.KeyProvider','master',NULL),('cce44c93-b4ce-4c29-9cef-9d6dda7c81fc','aes-generated','premier','aes-generated','org.keycloak.keys.KeyProvider','premier',NULL),('cef700fa-55bb-4dfc-8e93-5e65420ece40','Max Clients Limit','premier','max-clients','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','premier','anonymous'),('cf2cc210-a87e-4e86-853f-7b2875a6dd8c','Allowed Protocol Mapper Types','master','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','master','anonymous'),('efa3e330-c3b9-4aea-bdd4-cd3710b2a1a4',NULL,'premier','declarative-user-profile','org.keycloak.userprofile.UserProfileProvider','premier',NULL),('f0f47c9b-72e8-45bd-98ff-d98596075f77','hmac-generated','premier','hmac-generated','org.keycloak.keys.KeyProvider','premier',NULL);
/*!40000 ALTER TABLE `COMPONENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COMPONENT_CONFIG`
--

DROP TABLE IF EXISTS `COMPONENT_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COMPONENT_CONFIG` (
  `ID` varchar(36) NOT NULL,
  `COMPONENT_ID` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `VALUE` varchar(4000) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_COMPO_CONFIG_COMPO` (`COMPONENT_ID`),
  CONSTRAINT `FK_COMPONENT_CONFIG` FOREIGN KEY (`COMPONENT_ID`) REFERENCES `COMPONENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMPONENT_CONFIG`
--

LOCK TABLES `COMPONENT_CONFIG` WRITE;
/*!40000 ALTER TABLE `COMPONENT_CONFIG` DISABLE KEYS */;
INSERT INTO `COMPONENT_CONFIG` VALUES ('051e8dd6-8e8e-4ddf-9f86-4706732f75da','46632e05-7cc8-4751-a761-71232d35eb1c','allow-default-scopes','true'),('08877d0d-e4cd-46f3-a23d-87748d8ad90e','cf2cc210-a87e-4e86-853f-7b2875a6dd8c','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),('08e3803f-2063-4766-acc8-5be09e36cabf','cef700fa-55bb-4dfc-8e93-5e65420ece40','max-clients','200'),('13faa3c7-0a66-46d0-9dc9-09511c463681','9ac1fe82-f674-4ade-ba86-b7d660658a1c','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),('1552eff7-9e48-4e11-b6b6-8d6e826f0566','c52a38d9-cbd7-40e7-91ed-cafcbf06e951','priority','100'),('198966ba-205e-4f76-98d8-69e4fd4a80b3','f0f47c9b-72e8-45bd-98ff-d98596075f77','secret','0qX8zYWf4SRHIyd19zyLSkjpm-iuUCR2B9GrHpm5WtFio8Nbb_9LygsNAVqneCtiIGXOSMcgv8fKRP5ZVUUXww'),('1aa9d4ac-6960-4eeb-8d77-de3ef5806184','cf2cc210-a87e-4e86-853f-7b2875a6dd8c','allowed-protocol-mapper-types','oidc-address-mapper'),('26963da4-bf65-4f1e-ba77-028691d825ae','66546c43-7aac-4493-80ec-6984d6a8326e','algorithm','RSA-OAEP'),('285117ae-ea17-450b-aa97-52df57ce7f9c','9ac1fe82-f674-4ade-ba86-b7d660658a1c','allowed-protocol-mapper-types','saml-user-attribute-mapper'),('2986c8f3-c802-4bd9-9db2-004be29b4947','9ac1fe82-f674-4ade-ba86-b7d660658a1c','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),('2b941427-a4d9-478b-9571-80d9ef8a8035','cf2cc210-a87e-4e86-853f-7b2875a6dd8c','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),('2c812a33-2eb0-4408-80cf-a42927eda352','c64d23dd-0167-42eb-a37f-519fb2b77447','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),('2caae303-27c6-45a1-affb-604f3b34c340','f0f47c9b-72e8-45bd-98ff-d98596075f77','kid','bbcabd49-464a-4a5e-9fc9-d8ed5df2f510'),('2ff1430a-7d02-49f7-9aaf-d667803e7ea6','35e83b8d-6c8c-400e-83aa-2bd2058703f4','allow-default-scopes','true'),('30a06317-2fb9-4947-b7a7-82a59ac481d9','f0f47c9b-72e8-45bd-98ff-d98596075f77','algorithm','HS256'),('4025ec4a-f5f4-4e2a-bc02-86ad3366afa7','c92edf6b-8bf5-4c64-8b49-d508a1f9d749','certificate','MIICmzCCAYMCBgGAx8y9LDANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjIwNTE1MTI1NzA1WhcNMzIwNTE1MTI1ODQ1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCc4W7aJyXTF/gxG7XYVxKeQVdfx+uDmvWLUZUs1DfYWllY3SsP1dWL6/tbFS9WsacV4MfxEhUMvgs7BfqORySP43E94lhnUYMZnwaX2Oc6g07g4oNMeCgm30BuH9XDviDvWK+xuuHeQxCe6H+IxfdHOus13oRPnAI9yUM87iNW0gUOm6OJfMNHDL75ESidkZ815xhW2QEnIkziv4WWTk0iXROKjB4dRX1AXocgeMQR8U4DO9STzX+uWHNkMIFSxOhzoUZVVYMsz8TqnQDS7oNtKLGSG/0tIh3X8cPlF1UqLyyBkymI8ie4RrxMm2ZXIQmvMfZ4aVNONSuYOIjixUO9AgMBAAEwDQYJKoZIhvcNAQELBQADggEBADGtjp3C6NQLhmQrOBf28fa3uDdc8hJ/wVgiiiRvs3i3nbwt/Kb/5DNH/Ta5eXR/QnuRzj2fXgmK5SxDDRWaUw5nY141THnUroB65xfUtcQ0DJNvNnJyTCglIMBzCy2tPahdcrW9ImV380aPpKZoSMUf+EIXDT0jkQqF2tfvAmfgYy+svmCVpj6HYcgHEyeLTGePrGvUpW6OhIl1E+r3o0QtzfJaP4pX+6aRvbc6zMn2BKadsUZv8rdcQtwsKrGeKSj8VR5Vx5r3V0MhdnH18sDZzjPPhv6IEv0X7XGkJOitYCxzVwJj6lPy4AYEyb87WLhOHyM+tDhuYSpsQtqKydc='),('44ecb82f-83a9-4d03-963e-6852df693322','9ac1fe82-f674-4ade-ba86-b7d660658a1c','allowed-protocol-mapper-types','oidc-full-name-mapper'),('4a6ce017-198d-44cd-826c-7ebdea8bc464','c92edf6b-8bf5-4c64-8b49-d508a1f9d749','priority','100'),('51c6826e-00d4-4a4f-a845-fb37e62ec035','150a45c0-0656-4d2e-a5d1-7f20cffd0e8b','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),('5b60064d-abbd-4ea7-aa01-4b318bb7654c','35a98ab3-f35a-4054-ab46-d91e61439500','client-uris-must-match','true'),('5bd6df44-9130-48bf-a8c5-cced2d1f8fb4','c64d23dd-0167-42eb-a37f-519fb2b77447','allowed-protocol-mapper-types','oidc-address-mapper'),('5ca56409-d434-456f-893c-5144294e8dd9','1af41a6a-4526-490e-b2b8-0b125cd543f4','keyUse','SIG'),('5d7bef6e-daf8-43f1-a2b7-43b9eea39152','c64d23dd-0167-42eb-a37f-519fb2b77447','allowed-protocol-mapper-types','saml-user-property-mapper'),('60068098-90e7-4948-9f5a-c34c2624d090','cce44c93-b4ce-4c29-9cef-9d6dda7c81fc','kid','39609ccb-8ced-414d-8c68-0ba01483cf4d'),('61c81ef2-205c-4fed-ae64-f6fb96f440e7','c92edf6b-8bf5-4c64-8b49-d508a1f9d749','keyUse','SIG'),('645e8a29-7038-49d3-a595-96fc972f801e','9ac1fe82-f674-4ade-ba86-b7d660658a1c','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),('6d113ec9-9e67-4f83-8328-65825247e023','c64d23dd-0167-42eb-a37f-519fb2b77447','allowed-protocol-mapper-types','saml-role-list-mapper'),('6ff2a7b7-d9f2-479a-9fc5-fbebc1dc7ee7','51cfac42-e42a-4157-8385-e2bb9c9437bd','allow-default-scopes','true'),('78c060db-877a-44eb-8d37-cd8d42da25bb','9ac1fe82-f674-4ade-ba86-b7d660658a1c','allowed-protocol-mapper-types','saml-user-property-mapper'),('7995a1ec-0bb4-4cb0-b08e-7f773fa8d25a','76aff126-1583-4b50-912e-ac99a4910fca','client-uris-must-match','true'),('7ba5eb57-2b73-4e55-9717-54bf5bb88a1b','cce44c93-b4ce-4c29-9cef-9d6dda7c81fc','priority','100'),('7ff209fa-3a5b-49cd-97c5-dfc3f2b6e5fe','cf2cc210-a87e-4e86-853f-7b2875a6dd8c','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),('82ace92d-b3cd-4376-95a7-98b50b59547e','c52a38d9-cbd7-40e7-91ed-cafcbf06e951','algorithm','HS256'),('83e1f176-750d-414b-adbc-fce5d66c1ad7','150a45c0-0656-4d2e-a5d1-7f20cffd0e8b','allowed-protocol-mapper-types','saml-user-property-mapper'),('8697c87b-4ed1-4d5b-92a8-bcd0447d66bd','29301511-92ae-40f6-a3c4-be186021b316','keyUse','ENC'),('8eac465b-94fe-412d-936a-c3b7e8edad90','76aff126-1583-4b50-912e-ac99a4910fca','host-sending-registration-request-must-match','true'),('9325eb77-54b3-4f5c-b560-6c405f27c703','150a45c0-0656-4d2e-a5d1-7f20cffd0e8b','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),('96656930-0fc4-415a-9e63-7d85ae8d309c','1af41a6a-4526-490e-b2b8-0b125cd543f4','privateKey','MIIEpAIBAAKCAQEA15DvcgTCrtsZehFXViD0hMUx/DjFPgXTtBtwS65W75jjDZzQ33zBkuSOE9b2txsRHL2+4D4B3CUseqL+Z+CSBAmqv6I2XRBQzkIL+H5OVSZdTWL07h1r0N3IFfsJX4DhimcULpTDTBcJsJf1R0PSbsvoSAItnpwUtRitBE5Ds6XF3JwT97P8ggZubJcpQnBTkMDUQSmHTH6Z0Q9MCtZJFJlC70+wJReFv4/BEPvaKIq5V23Oe3+u+mzhhdkw3nMM0jgZAQ8+px7j8HWJaqGQX4wDmbWVHrNKVU2uLur/1c0fx5c7oMaaNDUAMKIs1TXasT995c7/kic0L3WxzzDUjQIDAQABAoIBAHEuriolibqZW3UWKc8VGo2jpC0T+awpDxDf30Q9U3QVyBFbpufQ7yobSuXr1jopwgBfOBsxM3TNJ990OTN9W+02zio0F2shp+vEDdj5KFPZAuAg9w0W8YcHC4lO94rndoRevt/+R9RpvDK2dphmadS2x00Xp7BBrzWusRkzpqRpjRwc5/clqZ9huwwQb9Dg4e+Sg1YOt7ssxiQn/EP1t0OfAkt/I51i+m1wxyvdLBWYYDVZuEbYvFJ5G3KBG9LOVzVmOe3/Z1B4CHQqwewklmRAUSMsadbaP3bdoZ1TyjPystC3jbohR/dhWKLFwTes5S61dhec1DFcgDiAeH/i4MECgYEA6zU/plsczBCXIms6srSRv/94Y09ZDcPnwHcBKk7t4+5QY8mNDiPjMYgh8eAAIIrNgA5yrkQ5T1tTf+0GhfMM9tbk79jPV52j2lkMxq5FkF8UT9ap/Io+eluaav9pkgC2sWPfPBJwCDo/bnWrmPizkouIfJm3NqI6sz5BH9pGRtkCgYEA6p8xMCT+Jh+40BOMMnTOrd7zOFqf2bb6vU/kQg1uoL8YEWBneS/FwvXzXLv4HBjgqv7WZDIW3qrq6dm5A10AcdG9u2Pn9JulUV4/moZjVOHuBxceAlkd2tgMvlmeY0jqwScvxislBWfksibSLsKWkikO1Qm1hdg3Pvlxgjn9stUCgYEAnEI09fzj5cJD1c7tIRoLFkXPohJt9FIpHdkxwfzL2DhT2edluXYoEpkBDCKnkvcDzUZL8/BJLqpaj8tVIRo2i6p6T8l2/hsxZvbwIPJYLrCr2tqe9bKWDU3cCaeDaEbnGHRkMxGAskaYK3crOCZJjlr6ouSwLjCa1MfQFiw5sgkCgYEAuR4j1EXL1U7AJkTWIFVzYVKA+xzd9Qzfp5Eqm0c321MLbWJwIfkkg2BFxQx2hczHL4Pkqqeuzb9znFFyHgo6OJPxrLH2KVTJSnsfmg+gvi+I/EUsI1QnLy26WFIjm1jECOSfWC9ghXRkyH/C5KwZ23bTwhloBRQE+wYbnlGdL4UCgYBRTIxjvSlI4NnG0VHIMAc/CIo7DSYLFRqY63/uD8OVXP9IQgLpm6fNtxYBDbzE0bGn/V/fi9VMAYkP/Nu98HkOQFHV5+afSaAQMo2YeVH+LLxoLBy1tYMbV5oxxfoYLfijs4rmleiWeTZoUUPqb5DSeD3sq8N0/bgwq5kTU599eQ=='),('991afb5d-b0b3-459b-a7c6-304adfa8285a','c64d23dd-0167-42eb-a37f-519fb2b77447','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),('99460970-31f1-4c51-9c0b-d7ad68f638d0','846362d6-e5f4-47ab-b19c-2595cac28c4c','secret','6GtS7Pii2n6We41Vc0XqDQ'),('a1b754a3-8da6-4e0b-9866-176c1f5014c7','f0f47c9b-72e8-45bd-98ff-d98596075f77','priority','100'),('a1e2915d-909b-4cee-be26-40086a456550','150a45c0-0656-4d2e-a5d1-7f20cffd0e8b','allowed-protocol-mapper-types','saml-role-list-mapper'),('a4502f9a-a62d-4e61-90b7-f5629869e271','cf2cc210-a87e-4e86-853f-7b2875a6dd8c','allowed-protocol-mapper-types','saml-user-attribute-mapper'),('ab0e788e-13a7-4a5a-a7df-05cd1c3aa692','29301511-92ae-40f6-a3c4-be186021b316','algorithm','RSA-OAEP'),('ad4f43c5-847f-409d-b050-d9741bf0b3bd','29301511-92ae-40f6-a3c4-be186021b316','privateKey','MIIEogIBAAKCAQEAsa92qfWMPWYW8ZWUHMSGJhgcpjfyfyJVU4b/WvsxMIPqOGDVQhLk1JH+Bu3Rc/4hHsqGKfsetc8Z47lpwT5VSPjB0Yi6OhMqLKhPv+u5W9M8zJPM3D7ByOKhuX1/1cVZhX1pCE/LZ5rBUJ3UoA1iP+dfAx5lSkFOKjxPXMPbJKb4qbooXpd/BF/2scz1DQeEh43TEc0zrNrsWJPq8wzgob/MLYW+E2yFve2D00LAL1NgNxrhh7K44LssP/u3egXzPBIcVtir8FbV1NLhWSRxQNiATtTiZqMsVIQKgn9lPaNpC/c+TsR+CLUfBEq+Dgu0k0ZiS6D/mgtMDLIRpzzmGwIDAQABAoIBAGtQzFyuPzs+E5FphAEz+Mm9OmBx3fZHKD3AhS3QFM92fNn8MhEsFCUG3+QTcrOZwyszqoBkeRHZuYs+is759MyT4YvKBp/Yv1oldbU2i8cX99qfUdWb2bKYnpDHaZQVE5J6QhuRBgrW/vbPvIHGU5bBCTN7AjYs5ya/MjeW2x5w7eUXD40Avusp1vm/iv3cruVQeoOIdSIDpyN029dw7mKqu1aHflnlFdqA4Ei6tP8Y/ZX2J+PWkhQdUZjAmMpslFTcuuMZSAlT1Z4EpLqm29Uj2QbDSYNCJrfZGhEiesyBtKsPBvlfMC2EP8JxdO7TwFh3BfS9p6R91XW8buK1PsECgYEA9k3JQvfUAIgX8sXIfAjsiXhHheeILbPP28DRynuLuKxRjDq3H//wDxcHaLwrjuA7eF2Vxgh099eqgJKDZwq2g7JaAhN2lYkxiiiK/9U55ew1KQHT2x5EIixcyUOPmwylGZ5PdBBU0GR29QQA+EzQ/yiZB5PwkF9BbgRfWCJdTWsCgYEAuK4mmUpbKNRQLTAUORTR2m/q1oK9a2ua3uAx/qb/Wk4Uw6Vvu3gCUXqapl2h8zIN0yJirMjxX1TlHqhsi9BGw6Vkv/1gfTh9RkerWPnmi04EbmzIoRqvt2xp1S8TGm9P0fPE7sh+BrwHISzDrXXxNBOWtxAxtMSnrhJZPW/+xhECgYBUE1tnO7encs1R9sen51fu2Rr5D37BswZ6CgjS6HdaU6AGkShfiPsF+6Nw0gLAY7SJMtDkZ5Cd5YVzHBA0xUhmDiSBXul0w/8gHRTNnZiE7qt60v/hZSR20dPec+x6TcexxgNzJ/v7or+khXhbScVxxAbwukQ80/c+ucleCWT1/wKBgBO1ciUVzFi1H8FSyjW1RRf8raEq3rAiEasLXgqBI+stPgYLF7t3+Tdc0DhE8c2UX+lSWBl8cFXuJ214J+1b0tF6SyA6GBwE9UmUyHJ8aOAg+VQXg+m9gVcf2MOJfI5rpqcPTsr01o49br1Zm6BdX9pg5Mqwjb1u5z4qcx+dXiEhAoGAboAIN4iyYriti3thQslTCvvI9MGZbZ7otIiSVcChTcGTbK1m47Op4MaNFTJF3QjS7ZLks9T0uGC5nAaAk9Lh3eTty5UDumr6t6ekYomFE6TxIHr8kUInWbUSZfk2rh9H6lgVIWn1O7g80BB5vueSkGM8rBrNa/jbgklcktRRVJM='),('ad54680f-d65a-4a49-acde-e84cc3a9398c','35a98ab3-f35a-4054-ab46-d91e61439500','host-sending-registration-request-must-match','true'),('b1bd3396-baed-4da3-ba17-f1c233e65371','150a45c0-0656-4d2e-a5d1-7f20cffd0e8b','allowed-protocol-mapper-types','oidc-address-mapper'),('b4c5b6c0-51b7-4dfb-96c3-2d3dc26e41c1','9ac1fe82-f674-4ade-ba86-b7d660658a1c','allowed-protocol-mapper-types','oidc-address-mapper'),('b536fc0a-dcb5-46a1-8df2-0e73f95c1f88','66546c43-7aac-4493-80ec-6984d6a8326e','priority','100'),('b8c1ba05-6924-4a34-997c-5e9f6b397db4','c92edf6b-8bf5-4c64-8b49-d508a1f9d749','privateKey','MIIEowIBAAKCAQEAnOFu2icl0xf4MRu12FcSnkFXX8frg5r1i1GVLNQ32FpZWN0rD9XVi+v7WxUvVrGnFeDH8RIVDL4LOwX6jkckj+NxPeJYZ1GDGZ8Gl9jnOoNO4OKDTHgoJt9Abh/Vw74g71ivsbrh3kMQnuh/iMX3RzrrNd6ET5wCPclDPO4jVtIFDpujiXzDRwy++REonZGfNecYVtkBJyJM4r+Flk5NIl0TioweHUV9QF6HIHjEEfFOAzvUk81/rlhzZDCBUsToc6FGVVWDLM/E6p0A0u6DbSixkhv9LSId1/HD5RdVKi8sgZMpiPInuEa8TJtmVyEJrzH2eGlTTjUrmDiI4sVDvQIDAQABAoIBAQCQquZBcAZWYm0yQ/5t8OWvYEwFfGN3aidygRoSS+Tvs2lfJBz4rlUNgeC5vpB33r1Y1H8slGMq6/mJRVsnZv2VXsTnr1mcdTNzJg27a37Xm4zanqc7ljZYmllc9Ch5KFRQwzTJra9p+ehS0c4Bv6TnX7LVa0wR6ai7d2R0xJl8DiBXcEVNlrbZyAAm+MAgSp+AAsY6gm2a6YN6Z8lgPp1X9/k5WmXzu33Kv0fcR98vgXFSbllaeqcFm584pcH91U3C/KVeWYkVCLNrmYuJThTn38/FYTpHpbM0aZyJxmziYGhRXUdx5R75oznGbKuK85wpFUWWMQVTfxlpp+x2QxPhAoGBAM/N7yWkj0HqykMnRHy+quGDTWpMZ2QwkxZq6NJaQaWCqwZAFvT281O0zsennHx6e8UTnTNAtNyUbzmo1nBPASjyrqiS5rY8wccIjzPyJ3COiG7FllZDCljb7Em62x2JTPFY+J56OLmSsp5BY9eHURK4OequZNDaDar6KbNCB6sVAoGBAMFD+ancHey24Dsft1FHxrSSGunimyiuMjKvjZalXjhIkavkYqtkXyBW5C5AsEdfvsM6QAeMIzmR2ogd+B2hkMHg+8xdDu44sIPUxjqgyE0eUsLqIroYacHMbU4QFA7BrWBJqJcmgtVlHw4STl5d4rvXLjRDAJ5oqiKsZS4Bj0AJAoGAPuYple5KgnxL/qmbHFsmJB53R06bGQNu8iEoGcvCBRQZKkop6Ln7CwI2eM5uGmuEnTGDqqjSVdYEGKLXTaVMR5W1ckcM2GppiRI5LlMExxgNieH60F94eU8QJX0Op9EQXhk9H9ME6n7R2/8U9n759j2XIkbpMyJdcrxH9P9ujMUCgYBRZB8wudKgbiPgwmqhgGjegulytkxBxZq+XdBzMRGNAoLWsUgchhjJtc5C7FtQs7HS5iUxCIONKy+tQ3HKiNA91lI0rrwq9xTfcCxLZIr2b17LV29oj/957m3aAktwK4ConFyzyzQuSnfZpTv74e4qzWRX/h+0lr+P+qphxaZegQKBgG601Pd9zkVPPjOVm8vzWNSX3cKagg/DTjtglqxzdHpGJ6QMJb+BseyzASJpyttQefEX4wnTHiQMluuZVHKcU2ovNmGoEqJLdRVlrQc61XN/+D0gazdKY8FlZyPE47fZaPe6zYYMmb0OJnmW0xN7jgxTCELsuftpdl2/lcG7hfWZ'),('c3fb0504-4743-47c8-93c5-1495d4414723','c64d23dd-0167-42eb-a37f-519fb2b77447','allowed-protocol-mapper-types','oidc-full-name-mapper'),('c6bcf08a-4529-42c3-89a2-2c3dc7d2f5b0','c52a38d9-cbd7-40e7-91ed-cafcbf06e951','secret','PyVIR1YlEEHDSPkYyJ5QDEhNopz7eYxuN1CCDw-CpPBoFGJAw0qXFcravnDuGvPKQ5aSV5FSb-EN7XvUgM7frQ'),('c99f6d88-67c2-420e-8d53-d8a589d9b094','150a45c0-0656-4d2e-a5d1-7f20cffd0e8b','allowed-protocol-mapper-types','saml-user-attribute-mapper'),('cc9d31e1-cf48-4a72-8412-e5d323349da4','66546c43-7aac-4493-80ec-6984d6a8326e','privateKey','MIIEowIBAAKCAQEAjxYv9OH7gfgShggw4KX/8pVZsEaeT4libnZ97FUwJSdcVFxTa6qrACJwbby4LWp0DPzRYEP11AI7W1S8qawoPb/jv8IaeysS7vImcIypTPFdhfqR8A2zxVZs8UN9wAvSDnbXTIj73gUsq1lGXS0mM0OQSH0Ja3JDwatnu7QJx4A2Df/Lc0y5HRRBBJHSqOz46KZibSosEfPVA3ejz8aaNd1baI7TAeVd11DHnY5TJonQbBwPG56fRprKfdu+tU3023v+JJnmQrwcMsvCYdrp3wMiggj2CZiDwTkpRVI/79c0mufcoR45m2q82/6hCE4IwQsO7ln6M8yEna4CnUuptQIDAQABAoIBACtIqe8pITz6vxe+iJKchKVsWnpBkog65gTGYWdJicvjcUGvwCh0s0/SGzKHASvz5PE81VWKmWWt2yjQpFWrV2z+jDWo0PvrVsnjhI9NbbVx2jm6R8VXT8dlUoVVRkf/C2cGujBTy+UoqY+X7Poou0KMsKvM7zmKkkaWxEV6u+6WPVrqgeCeToOFKQKwo1NGNfcInJJkVS2pcPC5ZTa1x5IGEtVzFBkxGTJWh6bfKhXVhFXkPF6biVKfRgDEd3BTbGtvTkNjUDjqyId/0zNko/Pc2jeFshxp48hO9U38j7iXk2MFQoortqocXJrs7669vr9dt7Uo09sKivBxiD7FVi0CgYEAyC1iL9Mk57jDeECjNJqMSQ8mOA5rbYi8jHRaYlWtHjXHm81rwA5J/SU+q7jt5c9amM/v75HU0i1+Sg0xQRxYSZ0swIYwCVUwt4WgKXxFlqng7/V9lbRmYKqgMma9opkC9CDjGLFxXT75v1baZFRNKnqCW1tqKFbb8ryPRSp2xGsCgYEAtv0dzD3LgFOLuaVsWdnT61l5TQdMsHya2QO21/n6GilBk7U/ikOc/+7UcxbcTiFAhLicvzWYyMvH2VhytC7yHwKaecV+YwNulCDGlTNswsg9qZAskulcBjZXSzsQqRnWVMSlt/KJ5QCNXSMWE55AnQZWZ4ftkp3unseVw1iL0l8CgYByJ998oo7DTsy6QTJRh2lFKMyE30RIXNgZySjaNz3YopbItScjiYKMSLcquvWAPvXNe5e7KZESozsIA+n41a9Lm8Svrlaqm9iCcEPcJLCSsSJD9d2+h/hyXBurYof2uAfFLRQVOuwJXyaSBXfaC3FOLjs02jb59j7MeNfDe+nrLQKBgQCMj+Zhy14U1xhPpLiUVHUrJfG9r8vDDhRMe0Pqp4Tsr6BF/EYwyTtChY0AUyErivNqf/04C82vAIoldIG30w/9rhxHSeOJ30sD0iF43qW/Ad4L8EmtGECuLPPlQBvOKaCwQNYjdNVj6YatcpQ0wa1UcVfR82IU6+guY5WxFsVg9QKBgE2gPQ4K46Cr5ST583bjghAOZAKbcWL+abPHvt0xQe1aEbD/3sS3fOHxO1amDEW9NCDTj/Sbg+XH/zROdSDRf9CEOJEAPAgduytOdjS4zXWfbUfqRiDyA9NcgLH7G2dG192gutAtSRMgJaMTH8DCXdwLU/fLUBAc//O7d2XVyPJd'),('cd50d7f9-3481-4f58-b45b-e17f29acc9d9','150a45c0-0656-4d2e-a5d1-7f20cffd0e8b','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),('ce49cd3a-0596-4e19-9711-fe6065c4058d','2b0f8443-2061-4ffc-b7ec-7ee0e67da92d','max-clients','200'),('d069b33d-8e74-4d8e-b6ed-a055cf861523','cf2cc210-a87e-4e86-853f-7b2875a6dd8c','allowed-protocol-mapper-types','saml-user-property-mapper'),('d17e1273-91b1-4fd6-82f6-e12a43b3ed4a','1af41a6a-4526-490e-b2b8-0b125cd543f4','certificate','MIICnTCCAYUCBgGAx9Z7HTANBgkqhkiG9w0BAQsFADASMRAwDgYDVQQDDAdwcmVtaWVyMB4XDTIyMDUxNTEzMDc0M1oXDTMyMDUxNTEzMDkyM1owEjEQMA4GA1UEAwwHcHJlbWllcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANeQ73IEwq7bGXoRV1Yg9ITFMfw4xT4F07QbcEuuVu+Y4w2c0N98wZLkjhPW9rcbERy9vuA+AdwlLHqi/mfgkgQJqr+iNl0QUM5CC/h+TlUmXU1i9O4da9DdyBX7CV+A4YpnFC6Uw0wXCbCX9UdD0m7L6EgCLZ6cFLUYrQROQ7OlxdycE/ez/IIGbmyXKUJwU5DA1EEph0x+mdEPTArWSRSZQu9PsCUXhb+PwRD72iiKuVdtznt/rvps4YXZMN5zDNI4GQEPPqce4/B1iWqhkF+MA5m1lR6zSlVNri7q/9XNH8eXO6DGmjQ1ADCiLNU12rE/feXO/5InNC91sc8w1I0CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAwMXICP87474dyBicsif5Zn6UiWlBdB3bSX+SRJ5bLXDCjnt0rXYQkNQ6SCFbezN2cx4AMKIzn/b5jJ8VcezglK0Sod0KtRr7P8Tf1i+2ap5wC+ii4ae3mG6hN5RGyAVEHA0JJcRbH9yC+JvNjsQgQURjIaoFjssBz3VCsbu9V2I2jm0Mv780k1x1tGwukN76jkRu+A1UEYlpWSz/pmy385cCYo5ICf+PViyf7Z93uBg7HKdqII6UnjTSMJug11/Y9f/2Hml+WdkJnovI+wle1fAtbORMmtPFCAKiOwKU6ui87PPbvotM16pzPlGgnc+E9NtQio1BUgPOke9YX1A3kQ=='),('d473da61-c0f8-4919-b02b-6dffb7317686','29301511-92ae-40f6-a3c4-be186021b316','certificate','MIICnTCCAYUCBgGAx9Z8gDANBgkqhkiG9w0BAQsFADASMRAwDgYDVQQDDAdwcmVtaWVyMB4XDTIyMDUxNTEzMDc0NFoXDTMyMDUxNTEzMDkyNFowEjEQMA4GA1UEAwwHcHJlbWllcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALGvdqn1jD1mFvGVlBzEhiYYHKY38n8iVVOG/1r7MTCD6jhg1UIS5NSR/gbt0XP+IR7Khin7HrXPGeO5acE+VUj4wdGIujoTKiyoT7/ruVvTPMyTzNw+wcjiobl9f9XFWYV9aQhPy2eawVCd1KANYj/nXwMeZUpBTio8T1zD2ySm+Km6KF6XfwRf9rHM9Q0HhIeN0xHNM6za7FiT6vMM4KG/zC2FvhNshb3tg9NCwC9TYDca4YeyuOC7LD/7t3oF8zwSHFbYq/BW1dTS4VkkcUDYgE7U4majLFSECoJ/ZT2jaQv3Pk7Efgi1HwRKvg4LtJNGYkug/5oLTAyyEac85hsCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAfPaM7cozcurG5zdDrXz4YE7oezXVf1i09l51+PbXpnWRHyN2e8TIsP6T/4jko3CReWg953Mins7Q5D1B9e/n2A51HtytKHO9g3louDHQrZOvdluZpiJs20ohb1/UBOovg3QLyiHzfwr1CepVBCYHbW5f17HgO2FNAdOlN23LGQRfL3NNgOjo8XdiqK7f53mfhytRIQI16eA7S/tkJY0oxjQSxBjSDg6D9Q0heJUJDHEkDa7pYJSJLHMN7WKPB289ooSoXe9vfD5H7WCf8AMt4/hN/x4WSMBNhquk68XS1dbK44/mhOejh43ajIp8TM06jAkkB0mQYd6rUGd+QQSxKQ=='),('d496cab2-4913-43cb-9a81-230e268c1a60','cf2cc210-a87e-4e86-853f-7b2875a6dd8c','allowed-protocol-mapper-types','saml-role-list-mapper'),('d6268bc7-82fd-40da-b301-85562c014bd2','c64d23dd-0167-42eb-a37f-519fb2b77447','allowed-protocol-mapper-types','saml-user-attribute-mapper'),('d6549a7c-0fef-4433-8c66-2c350c1425aa','66546c43-7aac-4493-80ec-6984d6a8326e','certificate','MIICmzCCAYMCBgGAx8y9kjANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjIwNTE1MTI1NzA1WhcNMzIwNTE1MTI1ODQ1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCPFi/04fuB+BKGCDDgpf/ylVmwRp5PiWJudn3sVTAlJ1xUXFNrqqsAInBtvLgtanQM/NFgQ/XUAjtbVLyprCg9v+O/whp7KxLu8iZwjKlM8V2F+pHwDbPFVmzxQ33AC9IOdtdMiPveBSyrWUZdLSYzQ5BIfQlrckPBq2e7tAnHgDYN/8tzTLkdFEEEkdKo7PjopmJtKiwR89UDd6PPxpo13VtojtMB5V3XUMedjlMmidBsHA8bnp9Gmsp92761TfTbe/4kmeZCvBwyy8Jh2unfAyKCCPYJmIPBOSlFUj/v1zSa59yhHjmbarzb/qEITgjBCw7uWfozzISdrgKdS6m1AgMBAAEwDQYJKoZIhvcNAQELBQADggEBADfdQggp4Lo393ZUfqChdbODP2R4598RLksLtz5bNiGqLPfiJJTdQEWUDDBf8lZBT830+VCf/FnRt6Hv+mwVk2y5kwJFymke5BOvD2uEZyo2ZR2njGqHwHwKvKDWcHYWtcy8xJ/L9878i1rMLYzljNDcjaZEGS5M559cwZ9/fu2EOgrcxItxJ9JZ5rEm5TnIpGkIYZOH6gHp0fJ6Pstr2qX6vR/WpbjP1ba95p/g3CHGJ20gZoeEctLeekH4Ny0Ib+Y7jN1Wu3C8KJqj/yPj5kxL7q+pnJl8qh20RTT+BKgfRCGIBvAvgSn1QnoMyn/MI7BYVzLNAE6tB+sr3lUYnnY='),('d90a7c23-0b8a-4f79-a83f-12912b7fb55d','9ac1fe82-f674-4ade-ba86-b7d660658a1c','allowed-protocol-mapper-types','saml-role-list-mapper'),('dcc217e8-ac48-43ee-b645-cb4ba1192441','c64d23dd-0167-42eb-a37f-519fb2b77447','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),('de057057-7411-4889-8b18-2e6cb6dbf39f','846362d6-e5f4-47ab-b19c-2595cac28c4c','priority','100'),('de686fe0-11e6-4c3b-9c6c-abeb8321557e','150a45c0-0656-4d2e-a5d1-7f20cffd0e8b','allowed-protocol-mapper-types','oidc-full-name-mapper'),('e0449830-ecb9-407d-ae23-5d2dab9413a7','42a01ae3-e184-4a50-aefa-6a0123366b88','allow-default-scopes','true'),('e9da7b0b-69c9-4771-b7dd-afb3944418ac','cf2cc210-a87e-4e86-853f-7b2875a6dd8c','allowed-protocol-mapper-types','oidc-full-name-mapper'),('ed3d186e-cdf4-4940-9d7d-f8fc0352d33c','1af41a6a-4526-490e-b2b8-0b125cd543f4','priority','100'),('f086285a-08e2-418e-8ebf-03e5921886da','c52a38d9-cbd7-40e7-91ed-cafcbf06e951','kid','5211ffc0-c83b-49e6-af95-ff8f9f09e1d3'),('f09c5729-3316-4545-811c-3c7324623569','29301511-92ae-40f6-a3c4-be186021b316','priority','100'),('f500c13c-40a6-4885-b15b-8724c47202fb','66546c43-7aac-4493-80ec-6984d6a8326e','keyUse','ENC'),('f958cf25-f0c8-45ca-a25a-97106ac9be09','cce44c93-b4ce-4c29-9cef-9d6dda7c81fc','secret','BhYuqFMhw0DzC7DUlkne7Q'),('fb31273d-33bb-480c-8fd2-1e278432efaf','846362d6-e5f4-47ab-b19c-2595cac28c4c','kid','9f8e0f38-f528-4dae-9481-5b11365be30a');
/*!40000 ALTER TABLE `COMPONENT_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COMPOSITE_ROLE`
--

DROP TABLE IF EXISTS `COMPOSITE_ROLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COMPOSITE_ROLE` (
  `COMPOSITE` varchar(36) NOT NULL,
  `CHILD_ROLE` varchar(36) NOT NULL,
  PRIMARY KEY (`COMPOSITE`,`CHILD_ROLE`),
  KEY `IDX_COMPOSITE` (`COMPOSITE`),
  KEY `IDX_COMPOSITE_CHILD` (`CHILD_ROLE`),
  CONSTRAINT `FK_A63WVEKFTU8JO1PNJ81E7MCE2` FOREIGN KEY (`COMPOSITE`) REFERENCES `KEYCLOAK_ROLE` (`ID`),
  CONSTRAINT `FK_GR7THLLB9LU8Q4VQA4524JJY8` FOREIGN KEY (`CHILD_ROLE`) REFERENCES `KEYCLOAK_ROLE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMPOSITE_ROLE`
--

LOCK TABLES `COMPOSITE_ROLE` WRITE;
/*!40000 ALTER TABLE `COMPOSITE_ROLE` DISABLE KEYS */;
INSERT INTO `COMPOSITE_ROLE` VALUES ('22256b30-238d-4c33-92c1-6eb484d7fc00','8cb575e4-4c35-416b-886d-ca98765e3ab0'),('22256b30-238d-4c33-92c1-6eb484d7fc00','c1d2f12e-4f4c-43f1-87c6-a31f1f416a97'),('277cc317-f98f-43ea-adfb-69234d489898','43a5ea3c-adb3-4e9d-86f0-2aa1131c4b61'),('28f520e8-7a1b-4bb2-a29d-0bacdf508da0','0c12efc7-039f-455f-80da-d6a854cf47b3'),('2e0919b2-6ca0-4186-a3f0-9aec5a9d2134','28f520e8-7a1b-4bb2-a29d-0bacdf508da0'),('2e0919b2-6ca0-4186-a3f0-9aec5a9d2134','4a1c95f1-4427-4f75-8d3f-2c080d1cdfc4'),('2e0919b2-6ca0-4186-a3f0-9aec5a9d2134','79050af3-eea9-4d0b-886f-40f2bfad293d'),('2e0919b2-6ca0-4186-a3f0-9aec5a9d2134','89994a78-11b0-4355-88d6-8213a64241ed'),('2e65cd6f-2c43-4943-a58d-c94680f9f9f9','486a91b4-5072-4c54-9273-0e4414d997be'),('2e65cd6f-2c43-4943-a58d-c94680f9f9f9','6c6ca9f0-6f57-4756-a720-9e7bea72a050'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','0a19f3e3-bef2-4f6e-9ce1-fb579297e8a3'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','22256b30-238d-4c33-92c1-6eb484d7fc00'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','28e315bd-8ec0-4877-82f7-651e97864ab8'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','37a817de-c9a3-48cf-9b5a-1d9528eb42a9'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','482f7fbc-7c5f-46f1-b87f-49560ad83895'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','5757278f-6b51-4ef6-91a3-535dca0e6c1d'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','6fcd981b-a812-4039-84e8-2f50d5c7c229'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','71d9b96e-8d57-4e38-9334-dd448e22018b'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','77477d4e-a150-4142-b064-5e193137c810'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','81536380-4f39-45e2-bdf9-b8591feba9b0'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','8cb575e4-4c35-416b-886d-ca98765e3ab0'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','b2912c58-372c-4bb9-9bf6-326e37144ad4'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','c1d2f12e-4f4c-43f1-87c6-a31f1f416a97'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','ce3c9dbc-c289-4a0f-8765-868190f39eef'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','d3914437-396b-4b4b-b24f-5f11c1ce039f'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','dcf2e2bf-d666-437d-a392-d0729ae438d6'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','ec13361c-8da3-4b45-aec8-7bf27af689e1'),('3e04f74b-d97b-4d0d-8683-66d987fceee3','f3891790-3438-478e-b56b-e85bfb9487e2'),('41b10923-3f04-4499-b032-63f96d5b0d36','4c1d179b-9bdd-4709-9337-8a93f80ab8c3'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','006afc92-fbc4-4bfa-97b7-d30f3d18bb07'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','155b700e-825a-46df-9fd4-58cd9ac53c11'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','2045428f-0df8-4dfa-9993-ac5862a39e38'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','2dfd389d-b2c6-4f11-99d7-ea06454f37aa'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','2e65cd6f-2c43-4943-a58d-c94680f9f9f9'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','41b10923-3f04-4499-b032-63f96d5b0d36'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','486a91b4-5072-4c54-9273-0e4414d997be'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','4c1d179b-9bdd-4709-9337-8a93f80ab8c3'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','4d141db3-35c0-44c4-8e11-e927bfc5b139'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','51ed1905-7003-44aa-bec6-d3be7f8cecab'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','5cdd5173-0d68-4bc6-9e8d-9458fdeb84c2'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','615ae9ab-29f0-4626-aef6-54b95ebacd6b'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','64c9b809-7224-446d-ae4c-73a4940290b1'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','67faf19b-ae4f-4d7d-823f-556344919faa'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','687373c8-6ab5-4967-bafd-28dd26369be3'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','6c6ca9f0-6f57-4756-a720-9e7bea72a050'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','6f893eb9-798b-4377-81a2-da3ebce7a372'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','6fda947e-52fe-4235-81e9-0057137425fe'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','7267f896-bc9a-4d81-9d43-281f01a59875'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','751fda26-6cf8-457a-957e-cf6a55cdfb71'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','828e83ce-089f-462e-95c7-8456e5148243'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','85e42549-455f-4d64-8fb8-b75a8cf1ac07'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','87644370-208d-4c34-bdfe-e04b48a6f15d'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','88ecd8a3-97e7-40f7-a9f1-4a6ffc2ed868'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','895e4b86-ddea-4f9f-aac6-57681db472a5'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','8ae0b6da-3fdb-4e21-82a7-e19d09c728b4'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','8b9bf70c-2e9d-4402-bac2-55dbca468cc6'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','910bf3e0-473f-478a-b098-ac403beef797'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','91b21f82-4682-4960-8e5f-1234288b96bd'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','9b1aa55f-9891-4eac-a720-913b00b95b39'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','c0f03b74-0356-4c3b-a1bf-91503d91305b'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','c3f9d5ca-bb6f-47d4-acd6-9d76fb180797'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','c8520bb0-032c-4f02-a627-e3f355545038'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','cabc9dcb-e7a9-4965-a230-7eaaab60664e'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','d1a3873f-98e0-40a9-857a-e8b7b0d13677'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','e4b4a2d0-9aaf-467c-b07b-22738f14b3d1'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','ea7058cc-e5c1-4634-ab32-dfe96596170d'),('71d9b96e-8d57-4e38-9334-dd448e22018b','dcf2e2bf-d666-437d-a392-d0729ae438d6'),('751fda26-6cf8-457a-957e-cf6a55cdfb71','85e42549-455f-4d64-8fb8-b75a8cf1ac07'),('751fda26-6cf8-457a-957e-cf6a55cdfb71','8ae0b6da-3fdb-4e21-82a7-e19d09c728b4'),('9cbed7db-4882-4874-8a88-cfbe4573212a','481478e3-16b7-41a9-a436-5c00e03f41ea'),('d1a3873f-98e0-40a9-857a-e8b7b0d13677','91b21f82-4682-4960-8e5f-1234288b96bd'),('e0d278f9-ea15-4ac5-8363-219d74ec1479','62ff6819-70a2-40f0-ada1-d1ae01271c0d'),('e0d278f9-ea15-4ac5-8363-219d74ec1479','9cbed7db-4882-4874-8a88-cfbe4573212a'),('e0d278f9-ea15-4ac5-8363-219d74ec1479','b526cd2a-450d-48a6-b3f7-62d52498a3fe'),('e0d278f9-ea15-4ac5-8363-219d74ec1479','da1f3d23-6e63-493d-932b-49b68e0ba6b1'),('fd908df2-b049-4e90-8db3-9506a0b692f8','cc00e6f5-22aa-4125-9768-a64b73513d42');
/*!40000 ALTER TABLE `COMPOSITE_ROLE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CREDENTIAL`
--

DROP TABLE IF EXISTS `CREDENTIAL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CREDENTIAL` (
  `ID` varchar(36) NOT NULL,
  `SALT` tinyblob,
  `TYPE` varchar(255) DEFAULT NULL,
  `USER_ID` varchar(36) DEFAULT NULL,
  `CREATED_DATE` bigint DEFAULT NULL,
  `USER_LABEL` varchar(255) DEFAULT NULL,
  `SECRET_DATA` longtext,
  `CREDENTIAL_DATA` longtext,
  `PRIORITY` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_USER_CREDENTIAL` (`USER_ID`),
  CONSTRAINT `FK_PFYR0GLASQYL0DEI3KL69R6V0` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CREDENTIAL`
--

LOCK TABLES `CREDENTIAL` WRITE;
/*!40000 ALTER TABLE `CREDENTIAL` DISABLE KEYS */;
INSERT INTO `CREDENTIAL` VALUES ('cacd0aa8-4ed0-4787-bd08-75e331ead501',NULL,'password','a9c03fe3-e211-43ac-a388-8f23780a0172',1652620084868,NULL,'{\"value\":\"vVkI4Eaf4D19T91kbMTgveLRr6Qt+TwvLiHvtX+IfOR+7jhnEk/cAEO8NQM3oIfO1WxE+0z6w2kcTO1kMxP5jg==\",\"salt\":\"ML+SBS1T6UJAZEUjNmd7HA==\",\"additionalParameters\":{}}','{\"hashIterations\":27500,\"algorithm\":\"pbkdf2-sha256\",\"additionalParameters\":{}}',10),('cfcf369f-fc6b-4db2-895c-fb400f922a14',NULL,'password','6dad8cd6-f02c-4c00-b54f-1d4f5a6046c9',1652620273249,NULL,'{\"value\":\"yaj5+l0uFKTD6AjVqzfYw8lnFAdooCjFL2BmExiwocgXCTtQBAieYCI1tzEXOFsOQ+BYfNDi2t57jhx52cJkjA==\",\"salt\":\"53MyZ0KmOi0CWmPGlM1DIA==\",\"additionalParameters\":{}}','{\"hashIterations\":27500,\"algorithm\":\"pbkdf2-sha256\",\"additionalParameters\":{}}',10);
/*!40000 ALTER TABLE `CREDENTIAL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DATABASECHANGELOG`
--

DROP TABLE IF EXISTS `DATABASECHANGELOG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATABASECHANGELOG` (
  `ID` varchar(255) NOT NULL,
  `AUTHOR` varchar(255) NOT NULL,
  `FILENAME` varchar(255) NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int NOT NULL,
  `EXECTYPE` varchar(10) NOT NULL,
  `MD5SUM` varchar(35) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `COMMENTS` varchar(255) DEFAULT NULL,
  `TAG` varchar(255) DEFAULT NULL,
  `LIQUIBASE` varchar(20) DEFAULT NULL,
  `CONTEXTS` varchar(255) DEFAULT NULL,
  `LABELS` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DATABASECHANGELOG`
--

LOCK TABLES `DATABASECHANGELOG` WRITE;
/*!40000 ALTER TABLE `DATABASECHANGELOG` DISABLE KEYS */;
INSERT INTO `DATABASECHANGELOG` VALUES ('1.0.0.Final-KEYCLOAK-5461','sthorger@redhat.com','META-INF/jpa-changelog-1.0.0.Final.xml','2022-05-15 12:58:25',1,'EXECUTED','7:4e70412f24a3f382c82183742ec79317','createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.0.0.Final-KEYCLOAK-5461','sthorger@redhat.com','META-INF/db2-jpa-changelog-1.0.0.Final.xml','2022-05-15 12:58:25',2,'MARK_RAN','7:cb16724583e9675711801c6875114f28','createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.1.0.Beta1','sthorger@redhat.com','META-INF/jpa-changelog-1.1.0.Beta1.xml','2022-05-15 12:58:26',3,'EXECUTED','7:0310eb8ba07cec616460794d42ade0fa','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.1.0.Final','sthorger@redhat.com','META-INF/jpa-changelog-1.1.0.Final.xml','2022-05-15 12:58:26',4,'EXECUTED','7:5d25857e708c3233ef4439df1f93f012','renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.2.0.Beta1','psilva@redhat.com','META-INF/jpa-changelog-1.2.0.Beta1.xml','2022-05-15 12:58:27',5,'EXECUTED','7:c7a54a1041d58eb3817a4a883b4d4e84','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.2.0.Beta1','psilva@redhat.com','META-INF/db2-jpa-changelog-1.2.0.Beta1.xml','2022-05-15 12:58:27',6,'MARK_RAN','7:2e01012df20974c1c2a605ef8afe25b7','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.2.0.RC1','bburke@redhat.com','META-INF/jpa-changelog-1.2.0.CR1.xml','2022-05-15 12:58:28',7,'EXECUTED','7:0f08df48468428e0f30ee59a8ec01a41','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.2.0.RC1','bburke@redhat.com','META-INF/db2-jpa-changelog-1.2.0.CR1.xml','2022-05-15 12:58:28',8,'MARK_RAN','7:a77ea2ad226b345e7d689d366f185c8c','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.2.0.Final','keycloak','META-INF/jpa-changelog-1.2.0.Final.xml','2022-05-15 12:58:28',9,'EXECUTED','7:a3377a2059aefbf3b90ebb4c4cc8e2ab','update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.3.0','bburke@redhat.com','META-INF/jpa-changelog-1.3.0.xml','2022-05-15 12:58:29',10,'EXECUTED','7:04c1dbedc2aa3e9756d1a1668e003451','delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.4.0','bburke@redhat.com','META-INF/jpa-changelog-1.4.0.xml','2022-05-15 12:58:29',11,'EXECUTED','7:36ef39ed560ad07062d956db861042ba','delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.4.0','bburke@redhat.com','META-INF/db2-jpa-changelog-1.4.0.xml','2022-05-15 12:58:29',12,'MARK_RAN','7:d909180b2530479a716d3f9c9eaea3d7','delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.5.0','bburke@redhat.com','META-INF/jpa-changelog-1.5.0.xml','2022-05-15 12:58:29',13,'EXECUTED','7:cf12b04b79bea5152f165eb41f3955f6','delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.6.1_from15','mposolda@redhat.com','META-INF/jpa-changelog-1.6.1.xml','2022-05-15 12:58:30',14,'EXECUTED','7:7e32c8f05c755e8675764e7d5f514509','addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.6.1_from16-pre','mposolda@redhat.com','META-INF/jpa-changelog-1.6.1.xml','2022-05-15 12:58:30',15,'MARK_RAN','7:980ba23cc0ec39cab731ce903dd01291','delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.6.1_from16','mposolda@redhat.com','META-INF/jpa-changelog-1.6.1.xml','2022-05-15 12:58:30',16,'MARK_RAN','7:2fa220758991285312eb84f3b4ff5336','dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.6.1','mposolda@redhat.com','META-INF/jpa-changelog-1.6.1.xml','2022-05-15 12:58:30',17,'EXECUTED','7:d41d8cd98f00b204e9800998ecf8427e','empty','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.7.0','bburke@redhat.com','META-INF/jpa-changelog-1.7.0.xml','2022-05-15 12:58:30',18,'EXECUTED','7:91ace540896df890cc00a0490ee52bbc','createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.8.0','mposolda@redhat.com','META-INF/jpa-changelog-1.8.0.xml','2022-05-15 12:58:31',19,'EXECUTED','7:c31d1646dfa2618a9335c00e07f89f24','addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.8.0-2','keycloak','META-INF/jpa-changelog-1.8.0.xml','2022-05-15 12:58:31',20,'EXECUTED','7:df8bc21027a4f7cbbb01f6344e89ce07','dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.8.0','mposolda@redhat.com','META-INF/db2-jpa-changelog-1.8.0.xml','2022-05-15 12:58:31',21,'MARK_RAN','7:f987971fe6b37d963bc95fee2b27f8df','addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.8.0-2','keycloak','META-INF/db2-jpa-changelog-1.8.0.xml','2022-05-15 12:58:31',22,'MARK_RAN','7:df8bc21027a4f7cbbb01f6344e89ce07','dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.9.0','mposolda@redhat.com','META-INF/jpa-changelog-1.9.0.xml','2022-05-15 12:58:31',23,'EXECUTED','7:ed2dc7f799d19ac452cbcda56c929e47','update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.9.1','keycloak','META-INF/jpa-changelog-1.9.1.xml','2022-05-15 12:58:31',24,'EXECUTED','7:80b5db88a5dda36ece5f235be8757615','modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.9.1','keycloak','META-INF/db2-jpa-changelog-1.9.1.xml','2022-05-15 12:58:31',25,'MARK_RAN','7:1437310ed1305a9b93f8848f301726ce','modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM','',NULL,'3.5.4',NULL,NULL,'2619503564'),('1.9.2','keycloak','META-INF/jpa-changelog-1.9.2.xml','2022-05-15 12:58:31',26,'EXECUTED','7:b82ffb34850fa0836be16deefc6a87c4','createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-2.0.0','psilva@redhat.com','META-INF/jpa-changelog-authz-2.0.0.xml','2022-05-15 12:58:32',27,'EXECUTED','7:9cc98082921330d8d9266decdd4bd658','createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-2.5.1','psilva@redhat.com','META-INF/jpa-changelog-authz-2.5.1.xml','2022-05-15 12:58:32',28,'EXECUTED','7:03d64aeed9cb52b969bd30a7ac0db57e','update tableName=RESOURCE_SERVER_POLICY','',NULL,'3.5.4',NULL,NULL,'2619503564'),('2.1.0-KEYCLOAK-5461','bburke@redhat.com','META-INF/jpa-changelog-2.1.0.xml','2022-05-15 12:58:33',29,'EXECUTED','7:f1f9fd8710399d725b780f463c6b21cd','createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('2.2.0','bburke@redhat.com','META-INF/jpa-changelog-2.2.0.xml','2022-05-15 12:58:33',30,'EXECUTED','7:53188c3eb1107546e6f765835705b6c1','addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('2.3.0','bburke@redhat.com','META-INF/jpa-changelog-2.3.0.xml','2022-05-15 12:58:33',31,'EXECUTED','7:d6e6f3bc57a0c5586737d1351725d4d4','createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('2.4.0','bburke@redhat.com','META-INF/jpa-changelog-2.4.0.xml','2022-05-15 12:58:33',32,'EXECUTED','7:454d604fbd755d9df3fd9c6329043aa5','customChange','',NULL,'3.5.4',NULL,NULL,'2619503564'),('2.5.0','bburke@redhat.com','META-INF/jpa-changelog-2.5.0.xml','2022-05-15 12:58:33',33,'EXECUTED','7:57e98a3077e29caf562f7dbf80c72600','customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION','',NULL,'3.5.4',NULL,NULL,'2619503564'),('2.5.0-unicode-oracle','hmlnarik@redhat.com','META-INF/jpa-changelog-2.5.0.xml','2022-05-15 12:58:33',34,'MARK_RAN','7:e4c7e8f2256210aee71ddc42f538b57a','modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('2.5.0-unicode-other-dbs','hmlnarik@redhat.com','META-INF/jpa-changelog-2.5.0.xml','2022-05-15 12:58:34',35,'EXECUTED','7:09a43c97e49bc626460480aa1379b522','modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('2.5.0-duplicate-email-support','slawomir@dabek.name','META-INF/jpa-changelog-2.5.0.xml','2022-05-15 12:58:34',36,'EXECUTED','7:26bfc7c74fefa9126f2ce702fb775553','addColumn tableName=REALM','',NULL,'3.5.4',NULL,NULL,'2619503564'),('2.5.0-unique-group-names','hmlnarik@redhat.com','META-INF/jpa-changelog-2.5.0.xml','2022-05-15 12:58:34',37,'EXECUTED','7:a161e2ae671a9020fff61e996a207377','addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP','',NULL,'3.5.4',NULL,NULL,'2619503564'),('2.5.1','bburke@redhat.com','META-INF/jpa-changelog-2.5.1.xml','2022-05-15 12:58:34',38,'EXECUTED','7:37fc1781855ac5388c494f1442b3f717','addColumn tableName=FED_USER_CONSENT','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.0.0','bburke@redhat.com','META-INF/jpa-changelog-3.0.0.xml','2022-05-15 12:58:34',39,'EXECUTED','7:13a27db0dae6049541136adad7261d27','addColumn tableName=IDENTITY_PROVIDER','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.2.0-fix','keycloak','META-INF/jpa-changelog-3.2.0.xml','2022-05-15 12:58:34',40,'MARK_RAN','7:550300617e3b59e8af3a6294df8248a3','addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.2.0-fix-with-keycloak-5416','keycloak','META-INF/jpa-changelog-3.2.0.xml','2022-05-15 12:58:34',41,'MARK_RAN','7:e3a9482b8931481dc2772a5c07c44f17','dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.2.0-fix-offline-sessions','hmlnarik','META-INF/jpa-changelog-3.2.0.xml','2022-05-15 12:58:34',42,'EXECUTED','7:72b07d85a2677cb257edb02b408f332d','customChange','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.2.0-fixed','keycloak','META-INF/jpa-changelog-3.2.0.xml','2022-05-15 12:58:35',43,'EXECUTED','7:a72a7858967bd414835d19e04d880312','addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.3.0','keycloak','META-INF/jpa-changelog-3.3.0.xml','2022-05-15 12:58:35',44,'EXECUTED','7:94edff7cf9ce179e7e85f0cd78a3cf2c','addColumn tableName=USER_ENTITY','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-3.4.0.CR1-resource-server-pk-change-part1','glavoie@gmail.com','META-INF/jpa-changelog-authz-3.4.0.CR1.xml','2022-05-15 12:58:35',45,'EXECUTED','7:6a48ce645a3525488a90fbf76adf3bb3','addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095','hmlnarik@redhat.com','META-INF/jpa-changelog-authz-3.4.0.CR1.xml','2022-05-15 12:58:35',46,'EXECUTED','7:e64b5dcea7db06077c6e57d3b9e5ca14','customChange','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-3.4.0.CR1-resource-server-pk-change-part3-fixed','glavoie@gmail.com','META-INF/jpa-changelog-authz-3.4.0.CR1.xml','2022-05-15 12:58:35',47,'MARK_RAN','7:fd8cf02498f8b1e72496a20afc75178c','dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex','glavoie@gmail.com','META-INF/jpa-changelog-authz-3.4.0.CR1.xml','2022-05-15 12:58:36',48,'EXECUTED','7:542794f25aa2b1fbabb7e577d6646319','addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authn-3.4.0.CR1-refresh-token-max-reuse','glavoie@gmail.com','META-INF/jpa-changelog-authz-3.4.0.CR1.xml','2022-05-15 12:58:36',49,'EXECUTED','7:edad604c882df12f74941dac3cc6d650','addColumn tableName=REALM','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.4.0','keycloak','META-INF/jpa-changelog-3.4.0.xml','2022-05-15 12:58:37',50,'EXECUTED','7:0f88b78b7b46480eb92690cbf5e44900','addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.4.0-KEYCLOAK-5230','hmlnarik@redhat.com','META-INF/jpa-changelog-3.4.0.xml','2022-05-15 12:58:37',51,'EXECUTED','7:d560e43982611d936457c327f872dd59','createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.4.1','psilva@redhat.com','META-INF/jpa-changelog-3.4.1.xml','2022-05-15 12:58:37',52,'EXECUTED','7:c155566c42b4d14ef07059ec3b3bbd8e','modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.4.2','keycloak','META-INF/jpa-changelog-3.4.2.xml','2022-05-15 12:58:37',53,'EXECUTED','7:b40376581f12d70f3c89ba8ddf5b7dea','update tableName=REALM','',NULL,'3.5.4',NULL,NULL,'2619503564'),('3.4.2-KEYCLOAK-5172','mkanis@redhat.com','META-INF/jpa-changelog-3.4.2.xml','2022-05-15 12:58:37',54,'EXECUTED','7:a1132cc395f7b95b3646146c2e38f168','update tableName=CLIENT','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.0.0-KEYCLOAK-6335','bburke@redhat.com','META-INF/jpa-changelog-4.0.0.xml','2022-05-15 12:58:37',55,'EXECUTED','7:d8dc5d89c789105cfa7ca0e82cba60af','createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.0.0-CLEANUP-UNUSED-TABLE','bburke@redhat.com','META-INF/jpa-changelog-4.0.0.xml','2022-05-15 12:58:37',56,'EXECUTED','7:7822e0165097182e8f653c35517656a3','dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.0.0-KEYCLOAK-6228','bburke@redhat.com','META-INF/jpa-changelog-4.0.0.xml','2022-05-15 12:58:37',57,'EXECUTED','7:c6538c29b9c9a08f9e9ea2de5c2b6375','dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.0.0-KEYCLOAK-5579-fixed','mposolda@redhat.com','META-INF/jpa-changelog-4.0.0.xml','2022-05-15 12:58:39',58,'EXECUTED','7:6d4893e36de22369cf73bcb051ded875','dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-4.0.0.CR1','psilva@redhat.com','META-INF/jpa-changelog-authz-4.0.0.CR1.xml','2022-05-15 12:58:39',59,'EXECUTED','7:57960fc0b0f0dd0563ea6f8b2e4a1707','createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-4.0.0.Beta3','psilva@redhat.com','META-INF/jpa-changelog-authz-4.0.0.Beta3.xml','2022-05-15 12:58:39',60,'EXECUTED','7:2b4b8bff39944c7097977cc18dbceb3b','addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-4.2.0.Final','mhajas@redhat.com','META-INF/jpa-changelog-authz-4.2.0.Final.xml','2022-05-15 12:58:39',61,'EXECUTED','7:2aa42a964c59cd5b8ca9822340ba33a8','createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-4.2.0.Final-KEYCLOAK-9944','hmlnarik@redhat.com','META-INF/jpa-changelog-authz-4.2.0.Final.xml','2022-05-15 12:58:39',62,'EXECUTED','7:9ac9e58545479929ba23f4a3087a0346','addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.2.0-KEYCLOAK-6313','wadahiro@gmail.com','META-INF/jpa-changelog-4.2.0.xml','2022-05-15 12:58:39',63,'EXECUTED','7:14d407c35bc4fe1976867756bcea0c36','addColumn tableName=REQUIRED_ACTION_PROVIDER','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.3.0-KEYCLOAK-7984','wadahiro@gmail.com','META-INF/jpa-changelog-4.3.0.xml','2022-05-15 12:58:39',64,'EXECUTED','7:241a8030c748c8548e346adee548fa93','update tableName=REQUIRED_ACTION_PROVIDER','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.6.0-KEYCLOAK-7950','psilva@redhat.com','META-INF/jpa-changelog-4.6.0.xml','2022-05-15 12:58:39',65,'EXECUTED','7:7d3182f65a34fcc61e8d23def037dc3f','update tableName=RESOURCE_SERVER_RESOURCE','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.6.0-KEYCLOAK-8377','keycloak','META-INF/jpa-changelog-4.6.0.xml','2022-05-15 12:58:39',66,'EXECUTED','7:b30039e00a0b9715d430d1b0636728fa','createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.6.0-KEYCLOAK-8555','gideonray@gmail.com','META-INF/jpa-changelog-4.6.0.xml','2022-05-15 12:58:39',67,'EXECUTED','7:3797315ca61d531780f8e6f82f258159','createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.7.0-KEYCLOAK-1267','sguilhen@redhat.com','META-INF/jpa-changelog-4.7.0.xml','2022-05-15 12:58:39',68,'EXECUTED','7:c7aa4c8d9573500c2d347c1941ff0301','addColumn tableName=REALM','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.7.0-KEYCLOAK-7275','keycloak','META-INF/jpa-changelog-4.7.0.xml','2022-05-15 12:58:39',69,'EXECUTED','7:b207faee394fc074a442ecd42185a5dd','renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('4.8.0-KEYCLOAK-8835','sguilhen@redhat.com','META-INF/jpa-changelog-4.8.0.xml','2022-05-15 12:58:40',70,'EXECUTED','7:ab9a9762faaba4ddfa35514b212c4922','addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM','',NULL,'3.5.4',NULL,NULL,'2619503564'),('authz-7.0.0-KEYCLOAK-10443','psilva@redhat.com','META-INF/jpa-changelog-authz-7.0.0.xml','2022-05-15 12:58:40',71,'EXECUTED','7:b9710f74515a6ccb51b72dc0d19df8c4','addColumn tableName=RESOURCE_SERVER','',NULL,'3.5.4',NULL,NULL,'2619503564'),('8.0.0-adding-credential-columns','keycloak','META-INF/jpa-changelog-8.0.0.xml','2022-05-15 12:58:40',72,'EXECUTED','7:ec9707ae4d4f0b7452fee20128083879','addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL','',NULL,'3.5.4',NULL,NULL,'2619503564'),('8.0.0-updating-credential-data-not-oracle-fixed','keycloak','META-INF/jpa-changelog-8.0.0.xml','2022-05-15 12:58:40',73,'EXECUTED','7:3979a0ae07ac465e920ca696532fc736','update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL','',NULL,'3.5.4',NULL,NULL,'2619503564'),('8.0.0-updating-credential-data-oracle-fixed','keycloak','META-INF/jpa-changelog-8.0.0.xml','2022-05-15 12:58:40',74,'MARK_RAN','7:5abfde4c259119d143bd2fbf49ac2bca','update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL','',NULL,'3.5.4',NULL,NULL,'2619503564'),('8.0.0-credential-cleanup-fixed','keycloak','META-INF/jpa-changelog-8.0.0.xml','2022-05-15 12:58:40',75,'EXECUTED','7:b48da8c11a3d83ddd6b7d0c8c2219345','dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('8.0.0-resource-tag-support','keycloak','META-INF/jpa-changelog-8.0.0.xml','2022-05-15 12:58:40',76,'EXECUTED','7:a73379915c23bfad3e8f5c6d5c0aa4bd','addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL','',NULL,'3.5.4',NULL,NULL,'2619503564'),('9.0.0-always-display-client','keycloak','META-INF/jpa-changelog-9.0.0.xml','2022-05-15 12:58:40',77,'EXECUTED','7:39e0073779aba192646291aa2332493d','addColumn tableName=CLIENT','',NULL,'3.5.4',NULL,NULL,'2619503564'),('9.0.0-drop-constraints-for-column-increase','keycloak','META-INF/jpa-changelog-9.0.0.xml','2022-05-15 12:58:40',78,'MARK_RAN','7:81f87368f00450799b4bf42ea0b3ec34','dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('9.0.0-increase-column-size-federated-fk','keycloak','META-INF/jpa-changelog-9.0.0.xml','2022-05-15 12:58:41',79,'EXECUTED','7:20b37422abb9fb6571c618148f013a15','modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('9.0.0-recreate-constraints-after-column-increase','keycloak','META-INF/jpa-changelog-9.0.0.xml','2022-05-15 12:58:41',80,'MARK_RAN','7:1970bb6cfb5ee800736b95ad3fb3c78a','addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('9.0.1-add-index-to-client.client_id','keycloak','META-INF/jpa-changelog-9.0.1.xml','2022-05-15 12:58:41',81,'EXECUTED','7:45d9b25fc3b455d522d8dcc10a0f4c80','createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT','',NULL,'3.5.4',NULL,NULL,'2619503564'),('9.0.1-KEYCLOAK-12579-drop-constraints','keycloak','META-INF/jpa-changelog-9.0.1.xml','2022-05-15 12:58:41',82,'MARK_RAN','7:890ae73712bc187a66c2813a724d037f','dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP','',NULL,'3.5.4',NULL,NULL,'2619503564'),('9.0.1-KEYCLOAK-12579-add-not-null-constraint','keycloak','META-INF/jpa-changelog-9.0.1.xml','2022-05-15 12:58:41',83,'EXECUTED','7:0a211980d27fafe3ff50d19a3a29b538','addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP','',NULL,'3.5.4',NULL,NULL,'2619503564'),('9.0.1-KEYCLOAK-12579-recreate-constraints','keycloak','META-INF/jpa-changelog-9.0.1.xml','2022-05-15 12:58:41',84,'MARK_RAN','7:a161e2ae671a9020fff61e996a207377','addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP','',NULL,'3.5.4',NULL,NULL,'2619503564'),('9.0.1-add-index-to-events','keycloak','META-INF/jpa-changelog-9.0.1.xml','2022-05-15 12:58:41',85,'EXECUTED','7:01c49302201bdf815b0a18d1f98a55dc','createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY','',NULL,'3.5.4',NULL,NULL,'2619503564'),('map-remove-ri','keycloak','META-INF/jpa-changelog-11.0.0.xml','2022-05-15 12:58:41',86,'EXECUTED','7:3dace6b144c11f53f1ad2c0361279b86','dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9','',NULL,'3.5.4',NULL,NULL,'2619503564'),('map-remove-ri','keycloak','META-INF/jpa-changelog-12.0.0.xml','2022-05-15 12:58:41',87,'EXECUTED','7:578d0b92077eaf2ab95ad0ec087aa903','dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('12.1.0-add-realm-localization-table','keycloak','META-INF/jpa-changelog-12.0.0.xml','2022-05-15 12:58:41',88,'EXECUTED','7:c95abe90d962c57a09ecaee57972835d','createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS','',NULL,'3.5.4',NULL,NULL,'2619503564'),('default-roles','keycloak','META-INF/jpa-changelog-13.0.0.xml','2022-05-15 12:58:41',89,'EXECUTED','7:f1313bcc2994a5c4dc1062ed6d8282d3','addColumn tableName=REALM; customChange','',NULL,'3.5.4',NULL,NULL,'2619503564'),('default-roles-cleanup','keycloak','META-INF/jpa-changelog-13.0.0.xml','2022-05-15 12:58:41',90,'EXECUTED','7:90d763b52eaffebefbcbde55f269508b','dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES','',NULL,'3.5.4',NULL,NULL,'2619503564'),('13.0.0-KEYCLOAK-16844','keycloak','META-INF/jpa-changelog-13.0.0.xml','2022-05-15 12:58:41',91,'EXECUTED','7:d554f0cb92b764470dccfa5e0014a7dd','createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION','',NULL,'3.5.4',NULL,NULL,'2619503564'),('map-remove-ri-13.0.0','keycloak','META-INF/jpa-changelog-13.0.0.xml','2022-05-15 12:58:41',92,'EXECUTED','7:73193e3ab3c35cf0f37ccea3bf783764','dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('13.0.0-KEYCLOAK-17992-drop-constraints','keycloak','META-INF/jpa-changelog-13.0.0.xml','2022-05-15 12:58:41',93,'MARK_RAN','7:90a1e74f92e9cbaa0c5eab80b8a037f3','dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT','',NULL,'3.5.4',NULL,NULL,'2619503564'),('13.0.0-increase-column-size-federated','keycloak','META-INF/jpa-changelog-13.0.0.xml','2022-05-15 12:58:41',94,'EXECUTED','7:5b9248f29cd047c200083cc6d8388b16','modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT','',NULL,'3.5.4',NULL,NULL,'2619503564'),('13.0.0-KEYCLOAK-17992-recreate-constraints','keycloak','META-INF/jpa-changelog-13.0.0.xml','2022-05-15 12:58:41',95,'MARK_RAN','7:64db59e44c374f13955489e8990d17a1','addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...','',NULL,'3.5.4',NULL,NULL,'2619503564'),('json-string-accomodation-fixed','keycloak','META-INF/jpa-changelog-13.0.0.xml','2022-05-15 12:58:41',96,'EXECUTED','7:329a578cdb43262fff975f0a7f6cda60','addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE','',NULL,'3.5.4',NULL,NULL,'2619503564'),('14.0.0-KEYCLOAK-11019','keycloak','META-INF/jpa-changelog-14.0.0.xml','2022-05-15 12:58:41',97,'EXECUTED','7:fae0de241ac0fd0bbc2b380b85e4f567','createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION','',NULL,'3.5.4',NULL,NULL,'2619503564'),('14.0.0-KEYCLOAK-18286','keycloak','META-INF/jpa-changelog-14.0.0.xml','2022-05-15 12:58:41',98,'MARK_RAN','7:075d54e9180f49bb0c64ca4218936e81','createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'3.5.4',NULL,NULL,'2619503564'),('14.0.0-KEYCLOAK-18286-revert','keycloak','META-INF/jpa-changelog-14.0.0.xml','2022-05-15 12:58:41',99,'MARK_RAN','7:06499836520f4f6b3d05e35a59324910','dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'3.5.4',NULL,NULL,'2619503564'),('14.0.0-KEYCLOAK-18286-supported-dbs','keycloak','META-INF/jpa-changelog-14.0.0.xml','2022-05-15 12:58:41',100,'EXECUTED','7:b558ad47ea0e4d3c3514225a49cc0d65','createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'3.5.4',NULL,NULL,'2619503564'),('14.0.0-KEYCLOAK-18286-unsupported-dbs','keycloak','META-INF/jpa-changelog-14.0.0.xml','2022-05-15 12:58:41',101,'MARK_RAN','7:3d2b23076e59c6f70bae703aa01be35b','createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES','',NULL,'3.5.4',NULL,NULL,'2619503564'),('KEYCLOAK-17267-add-index-to-user-attributes','keycloak','META-INF/jpa-changelog-14.0.0.xml','2022-05-15 12:58:41',102,'EXECUTED','7:1a7f28ff8d9e53aeb879d76ea3d9341a','createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE','',NULL,'3.5.4',NULL,NULL,'2619503564'),('KEYCLOAK-18146-add-saml-art-binding-identifier','keycloak','META-INF/jpa-changelog-14.0.0.xml','2022-05-15 12:58:41',103,'EXECUTED','7:2fd554456fed4a82c698c555c5b751b6','customChange','',NULL,'3.5.4',NULL,NULL,'2619503564'),('15.0.0-KEYCLOAK-18467','keycloak','META-INF/jpa-changelog-15.0.0.xml','2022-05-15 12:58:41',104,'EXECUTED','7:b06356d66c2790ecc2ae54ba0458397a','addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...','',NULL,'3.5.4',NULL,NULL,'2619503564');
/*!40000 ALTER TABLE `DATABASECHANGELOG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DATABASECHANGELOGLOCK`
--

DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DATABASECHANGELOGLOCK`
--

LOCK TABLES `DATABASECHANGELOGLOCK` WRITE;
/*!40000 ALTER TABLE `DATABASECHANGELOGLOCK` DISABLE KEYS */;
INSERT INTO `DATABASECHANGELOGLOCK` VALUES (1,_binary '\0',NULL,NULL),(1000,_binary '\0',NULL,NULL),(1001,_binary '\0',NULL,NULL);
/*!40000 ALTER TABLE `DATABASECHANGELOGLOCK` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DEFAULT_CLIENT_SCOPE`
--

DROP TABLE IF EXISTS `DEFAULT_CLIENT_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DEFAULT_CLIENT_SCOPE` (
  `REALM_ID` varchar(36) NOT NULL,
  `SCOPE_ID` varchar(36) NOT NULL,
  `DEFAULT_SCOPE` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`REALM_ID`,`SCOPE_ID`),
  KEY `IDX_DEFCLS_REALM` (`REALM_ID`),
  KEY `IDX_DEFCLS_SCOPE` (`SCOPE_ID`),
  CONSTRAINT `FK_R_DEF_CLI_SCOPE_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DEFAULT_CLIENT_SCOPE`
--

LOCK TABLES `DEFAULT_CLIENT_SCOPE` WRITE;
/*!40000 ALTER TABLE `DEFAULT_CLIENT_SCOPE` DISABLE KEYS */;
INSERT INTO `DEFAULT_CLIENT_SCOPE` VALUES ('master','46a22422-7357-44f2-b7a2-c09757855ada',_binary ''),('master','4ca73df8-9b1b-4095-933e-a725d4abf31a',_binary '\0'),('master','73a2d837-3a42-4133-908e-ca54e2f29677',_binary ''),('master','8f98f9e9-29c7-4353-8944-1efc25c0ee38',_binary '\0'),('master','95d5c0ad-2f1e-4352-82f9-413423c761b6',_binary ''),('master','ba614954-79b7-424b-a619-8a1f3bac41ba',_binary ''),('master','cc333c37-309e-4b46-b1be-b61953eb5180',_binary ''),('master','e9106541-1d67-42b4-95c7-04c07d06c903',_binary '\0'),('master','f9556e3c-e301-443c-8b68-f59b54f716ef',_binary '\0'),('premier','1b8b705a-46a0-401a-b3fe-5bdc0f8bed62',_binary ''),('premier','260bb8f9-c0c3-43a5-acf4-07c78bd3fca7',_binary ''),('premier','3de019da-3ffd-4a07-9cdb-8ad42a185ea2',_binary ''),('premier','45738afe-75d9-4d0f-a13c-6e5a4c879648',_binary '\0'),('premier','59680041-0490-428f-a752-fa7af29388bb',_binary '\0'),('premier','8ad5ab9f-7492-4752-bac7-8ff177e1d54e',_binary ''),('premier','9db15b72-b3ed-45b9-bb2e-eacb41208941',_binary '\0'),('premier','d0fd93f7-9c0c-47d5-b15b-e6528c90a942',_binary '\0'),('premier','fa0593b6-5702-4790-b2b2-3b78c1bf4c5f',_binary '');
/*!40000 ALTER TABLE `DEFAULT_CLIENT_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EVENT_ENTITY`
--

DROP TABLE IF EXISTS `EVENT_ENTITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EVENT_ENTITY` (
  `ID` varchar(36) NOT NULL,
  `CLIENT_ID` varchar(255) DEFAULT NULL,
  `DETAILS_JSON` text,
  `ERROR` varchar(255) DEFAULT NULL,
  `IP_ADDRESS` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(255) DEFAULT NULL,
  `SESSION_ID` varchar(255) DEFAULT NULL,
  `EVENT_TIME` bigint DEFAULT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `USER_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_EVENT_TIME` (`REALM_ID`,`EVENT_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EVENT_ENTITY`
--

LOCK TABLES `EVENT_ENTITY` WRITE;
/*!40000 ALTER TABLE `EVENT_ENTITY` DISABLE KEYS */;
/*!40000 ALTER TABLE `EVENT_ENTITY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FEDERATED_IDENTITY`
--

DROP TABLE IF EXISTS `FEDERATED_IDENTITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FEDERATED_IDENTITY` (
  `IDENTITY_PROVIDER` varchar(255) NOT NULL,
  `REALM_ID` varchar(36) DEFAULT NULL,
  `FEDERATED_USER_ID` varchar(255) DEFAULT NULL,
  `FEDERATED_USERNAME` varchar(255) DEFAULT NULL,
  `TOKEN` text,
  `USER_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`IDENTITY_PROVIDER`,`USER_ID`),
  KEY `IDX_FEDIDENTITY_USER` (`USER_ID`),
  KEY `IDX_FEDIDENTITY_FEDUSER` (`FEDERATED_USER_ID`),
  CONSTRAINT `FK404288B92EF007A6` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FEDERATED_IDENTITY`
--

LOCK TABLES `FEDERATED_IDENTITY` WRITE;
/*!40000 ALTER TABLE `FEDERATED_IDENTITY` DISABLE KEYS */;
/*!40000 ALTER TABLE `FEDERATED_IDENTITY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FEDERATED_USER`
--

DROP TABLE IF EXISTS `FEDERATED_USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FEDERATED_USER` (
  `ID` varchar(255) NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FEDERATED_USER`
--

LOCK TABLES `FEDERATED_USER` WRITE;
/*!40000 ALTER TABLE `FEDERATED_USER` DISABLE KEYS */;
/*!40000 ALTER TABLE `FEDERATED_USER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_ATTRIBUTE`
--

DROP TABLE IF EXISTS `FED_USER_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_ATTRIBUTE` (
  `ID` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `USER_ID` varchar(255) NOT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) DEFAULT NULL,
  `VALUE` text,
  PRIMARY KEY (`ID`),
  KEY `IDX_FU_ATTRIBUTE` (`USER_ID`,`REALM_ID`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_ATTRIBUTE`
--

LOCK TABLES `FED_USER_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `FED_USER_ATTRIBUTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_CONSENT`
--

DROP TABLE IF EXISTS `FED_USER_CONSENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_CONSENT` (
  `ID` varchar(36) NOT NULL,
  `CLIENT_ID` varchar(255) DEFAULT NULL,
  `USER_ID` varchar(255) NOT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) DEFAULT NULL,
  `CREATED_DATE` bigint DEFAULT NULL,
  `LAST_UPDATED_DATE` bigint DEFAULT NULL,
  `CLIENT_STORAGE_PROVIDER` varchar(36) DEFAULT NULL,
  `EXTERNAL_CLIENT_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_FU_CONSENT` (`USER_ID`,`CLIENT_ID`),
  KEY `IDX_FU_CONSENT_RU` (`REALM_ID`,`USER_ID`),
  KEY `IDX_FU_CNSNT_EXT` (`USER_ID`,`CLIENT_STORAGE_PROVIDER`,`EXTERNAL_CLIENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_CONSENT`
--

LOCK TABLES `FED_USER_CONSENT` WRITE;
/*!40000 ALTER TABLE `FED_USER_CONSENT` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_CONSENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_CONSENT_CL_SCOPE`
--

DROP TABLE IF EXISTS `FED_USER_CONSENT_CL_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_CONSENT_CL_SCOPE` (
  `USER_CONSENT_ID` varchar(36) NOT NULL,
  `SCOPE_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`USER_CONSENT_ID`,`SCOPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_CONSENT_CL_SCOPE`
--

LOCK TABLES `FED_USER_CONSENT_CL_SCOPE` WRITE;
/*!40000 ALTER TABLE `FED_USER_CONSENT_CL_SCOPE` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_CONSENT_CL_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_CREDENTIAL`
--

DROP TABLE IF EXISTS `FED_USER_CREDENTIAL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_CREDENTIAL` (
  `ID` varchar(36) NOT NULL,
  `SALT` tinyblob,
  `TYPE` varchar(255) DEFAULT NULL,
  `CREATED_DATE` bigint DEFAULT NULL,
  `USER_ID` varchar(255) NOT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) DEFAULT NULL,
  `USER_LABEL` varchar(255) DEFAULT NULL,
  `SECRET_DATA` longtext,
  `CREDENTIAL_DATA` longtext,
  `PRIORITY` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_FU_CREDENTIAL` (`USER_ID`,`TYPE`),
  KEY `IDX_FU_CREDENTIAL_RU` (`REALM_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_CREDENTIAL`
--

LOCK TABLES `FED_USER_CREDENTIAL` WRITE;
/*!40000 ALTER TABLE `FED_USER_CREDENTIAL` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_CREDENTIAL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_GROUP_MEMBERSHIP`
--

DROP TABLE IF EXISTS `FED_USER_GROUP_MEMBERSHIP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_GROUP_MEMBERSHIP` (
  `GROUP_ID` varchar(36) NOT NULL,
  `USER_ID` varchar(255) NOT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`GROUP_ID`,`USER_ID`),
  KEY `IDX_FU_GROUP_MEMBERSHIP` (`USER_ID`,`GROUP_ID`),
  KEY `IDX_FU_GROUP_MEMBERSHIP_RU` (`REALM_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_GROUP_MEMBERSHIP`
--

LOCK TABLES `FED_USER_GROUP_MEMBERSHIP` WRITE;
/*!40000 ALTER TABLE `FED_USER_GROUP_MEMBERSHIP` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_GROUP_MEMBERSHIP` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_REQUIRED_ACTION`
--

DROP TABLE IF EXISTS `FED_USER_REQUIRED_ACTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_REQUIRED_ACTION` (
  `REQUIRED_ACTION` varchar(255) NOT NULL DEFAULT ' ',
  `USER_ID` varchar(255) NOT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`REQUIRED_ACTION`,`USER_ID`),
  KEY `IDX_FU_REQUIRED_ACTION` (`USER_ID`,`REQUIRED_ACTION`),
  KEY `IDX_FU_REQUIRED_ACTION_RU` (`REALM_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_REQUIRED_ACTION`
--

LOCK TABLES `FED_USER_REQUIRED_ACTION` WRITE;
/*!40000 ALTER TABLE `FED_USER_REQUIRED_ACTION` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_REQUIRED_ACTION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FED_USER_ROLE_MAPPING`
--

DROP TABLE IF EXISTS `FED_USER_ROLE_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FED_USER_ROLE_MAPPING` (
  `ROLE_ID` varchar(36) NOT NULL,
  `USER_ID` varchar(255) NOT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  `STORAGE_PROVIDER_ID` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`ROLE_ID`,`USER_ID`),
  KEY `IDX_FU_ROLE_MAPPING` (`USER_ID`,`ROLE_ID`),
  KEY `IDX_FU_ROLE_MAPPING_RU` (`REALM_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FED_USER_ROLE_MAPPING`
--

LOCK TABLES `FED_USER_ROLE_MAPPING` WRITE;
/*!40000 ALTER TABLE `FED_USER_ROLE_MAPPING` DISABLE KEYS */;
/*!40000 ALTER TABLE `FED_USER_ROLE_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GROUP_ATTRIBUTE`
--

DROP TABLE IF EXISTS `GROUP_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GROUP_ATTRIBUTE` (
  `ID` varchar(36) NOT NULL DEFAULT 'sybase-needs-something-here',
  `NAME` varchar(255) NOT NULL,
  `VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `GROUP_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_GROUP_ATTR_GROUP` (`GROUP_ID`),
  CONSTRAINT `FK_GROUP_ATTRIBUTE_GROUP` FOREIGN KEY (`GROUP_ID`) REFERENCES `KEYCLOAK_GROUP` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GROUP_ATTRIBUTE`
--

LOCK TABLES `GROUP_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `GROUP_ATTRIBUTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `GROUP_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GROUP_ROLE_MAPPING`
--

DROP TABLE IF EXISTS `GROUP_ROLE_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GROUP_ROLE_MAPPING` (
  `ROLE_ID` varchar(36) NOT NULL,
  `GROUP_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`ROLE_ID`,`GROUP_ID`),
  KEY `IDX_GROUP_ROLE_MAPP_GROUP` (`GROUP_ID`),
  CONSTRAINT `FK_GROUP_ROLE_GROUP` FOREIGN KEY (`GROUP_ID`) REFERENCES `KEYCLOAK_GROUP` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GROUP_ROLE_MAPPING`
--

LOCK TABLES `GROUP_ROLE_MAPPING` WRITE;
/*!40000 ALTER TABLE `GROUP_ROLE_MAPPING` DISABLE KEYS */;
/*!40000 ALTER TABLE `GROUP_ROLE_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IDENTITY_PROVIDER`
--

DROP TABLE IF EXISTS `IDENTITY_PROVIDER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `IDENTITY_PROVIDER` (
  `INTERNAL_ID` varchar(36) NOT NULL,
  `ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `PROVIDER_ALIAS` varchar(255) DEFAULT NULL,
  `PROVIDER_ID` varchar(255) DEFAULT NULL,
  `STORE_TOKEN` bit(1) NOT NULL DEFAULT b'0',
  `AUTHENTICATE_BY_DEFAULT` bit(1) NOT NULL DEFAULT b'0',
  `REALM_ID` varchar(36) DEFAULT NULL,
  `ADD_TOKEN_ROLE` bit(1) NOT NULL DEFAULT b'1',
  `TRUST_EMAIL` bit(1) NOT NULL DEFAULT b'0',
  `FIRST_BROKER_LOGIN_FLOW_ID` varchar(36) DEFAULT NULL,
  `POST_BROKER_LOGIN_FLOW_ID` varchar(36) DEFAULT NULL,
  `PROVIDER_DISPLAY_NAME` varchar(255) DEFAULT NULL,
  `LINK_ONLY` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`INTERNAL_ID`),
  UNIQUE KEY `UK_2DAELWNIBJI49AVXSRTUF6XJ33` (`PROVIDER_ALIAS`,`REALM_ID`),
  KEY `IDX_IDENT_PROV_REALM` (`REALM_ID`),
  CONSTRAINT `FK2B4EBC52AE5C3B34` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IDENTITY_PROVIDER`
--

LOCK TABLES `IDENTITY_PROVIDER` WRITE;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER` DISABLE KEYS */;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IDENTITY_PROVIDER_CONFIG`
--

DROP TABLE IF EXISTS `IDENTITY_PROVIDER_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `IDENTITY_PROVIDER_CONFIG` (
  `IDENTITY_PROVIDER_ID` varchar(36) NOT NULL,
  `VALUE` longtext,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`IDENTITY_PROVIDER_ID`,`NAME`),
  CONSTRAINT `FKDC4897CF864C4E43` FOREIGN KEY (`IDENTITY_PROVIDER_ID`) REFERENCES `IDENTITY_PROVIDER` (`INTERNAL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IDENTITY_PROVIDER_CONFIG`
--

LOCK TABLES `IDENTITY_PROVIDER_CONFIG` WRITE;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IDENTITY_PROVIDER_MAPPER`
--

DROP TABLE IF EXISTS `IDENTITY_PROVIDER_MAPPER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `IDENTITY_PROVIDER_MAPPER` (
  `ID` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `IDP_ALIAS` varchar(255) NOT NULL,
  `IDP_MAPPER_NAME` varchar(255) NOT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_ID_PROV_MAPP_REALM` (`REALM_ID`),
  CONSTRAINT `FK_IDPM_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IDENTITY_PROVIDER_MAPPER`
--

LOCK TABLES `IDENTITY_PROVIDER_MAPPER` WRITE;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER_MAPPER` DISABLE KEYS */;
/*!40000 ALTER TABLE `IDENTITY_PROVIDER_MAPPER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IDP_MAPPER_CONFIG`
--

DROP TABLE IF EXISTS `IDP_MAPPER_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `IDP_MAPPER_CONFIG` (
  `IDP_MAPPER_ID` varchar(36) NOT NULL,
  `VALUE` longtext,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`IDP_MAPPER_ID`,`NAME`),
  CONSTRAINT `FK_IDPMCONFIG` FOREIGN KEY (`IDP_MAPPER_ID`) REFERENCES `IDENTITY_PROVIDER_MAPPER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IDP_MAPPER_CONFIG`
--

LOCK TABLES `IDP_MAPPER_CONFIG` WRITE;
/*!40000 ALTER TABLE `IDP_MAPPER_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `IDP_MAPPER_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `KEYCLOAK_GROUP`
--

DROP TABLE IF EXISTS `KEYCLOAK_GROUP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `KEYCLOAK_GROUP` (
  `ID` varchar(36) NOT NULL,
  `NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `PARENT_GROUP` varchar(36) NOT NULL,
  `REALM_ID` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SIBLING_NAMES` (`REALM_ID`,`PARENT_GROUP`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KEYCLOAK_GROUP`
--

LOCK TABLES `KEYCLOAK_GROUP` WRITE;
/*!40000 ALTER TABLE `KEYCLOAK_GROUP` DISABLE KEYS */;
/*!40000 ALTER TABLE `KEYCLOAK_GROUP` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `KEYCLOAK_ROLE`
--

DROP TABLE IF EXISTS `KEYCLOAK_ROLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `KEYCLOAK_ROLE` (
  `ID` varchar(36) NOT NULL,
  `CLIENT_REALM_CONSTRAINT` varchar(255) DEFAULT NULL,
  `CLIENT_ROLE` bit(1) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `REALM_ID` varchar(255) DEFAULT NULL,
  `CLIENT` varchar(36) DEFAULT NULL,
  `REALM` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_J3RWUVD56ONTGSUHOGM184WW2-2` (`NAME`,`CLIENT_REALM_CONSTRAINT`),
  KEY `IDX_KEYCLOAK_ROLE_CLIENT` (`CLIENT`),
  KEY `IDX_KEYCLOAK_ROLE_REALM` (`REALM`),
  CONSTRAINT `FK_6VYQFE4CN4WLQ8R6KT5VDSJ5C` FOREIGN KEY (`REALM`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KEYCLOAK_ROLE`
--

LOCK TABLES `KEYCLOAK_ROLE` WRITE;
/*!40000 ALTER TABLE `KEYCLOAK_ROLE` DISABLE KEYS */;
INSERT INTO `KEYCLOAK_ROLE` VALUES ('006afc92-fbc4-4bfa-97b7-d30f3d18bb07','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_impersonation}','impersonation','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('0a19f3e3-bef2-4f6e-9ce1-fb579297e8a3','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_view-realm}','view-realm','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('0c12efc7-039f-455f-80da-d6a854cf47b3','f2da4c42-aebd-4280-a1b4-96186777b481',_binary '','${role_manage-account-links}','manage-account-links','master','f2da4c42-aebd-4280-a1b4-96186777b481',NULL),('155b700e-825a-46df-9fd4-58cd9ac53c11','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_view-authorization}','view-authorization','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('2045428f-0df8-4dfa-9993-ac5862a39e38','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_view-identity-providers}','view-identity-providers','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('22256b30-238d-4c33-92c1-6eb484d7fc00','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_view-users}','view-users','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('277cc317-f98f-43ea-adfb-69234d489898','f2da4c42-aebd-4280-a1b4-96186777b481',_binary '','${role_manage-consent}','manage-consent','master','f2da4c42-aebd-4280-a1b4-96186777b481',NULL),('28e315bd-8ec0-4877-82f7-651e97864ab8','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_view-identity-providers}','view-identity-providers','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('28f520e8-7a1b-4bb2-a29d-0bacdf508da0','f2da4c42-aebd-4280-a1b4-96186777b481',_binary '','${role_manage-account}','manage-account','master','f2da4c42-aebd-4280-a1b4-96186777b481',NULL),('2dfd389d-b2c6-4f11-99d7-ea06454f37aa','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_create-client}','create-client','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('2e0919b2-6ca0-4186-a3f0-9aec5a9d2134','master',_binary '\0','${role_default-roles}','default-roles-master','master',NULL,NULL),('2e65cd6f-2c43-4943-a58d-c94680f9f9f9','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_view-users}','view-users','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('31ca7a4e-6b0c-4067-b794-b803825ba6e3','8a8e33ae-dca0-4911-b256-73f48466d04c',_binary '','${role_read-token}','read-token','master','8a8e33ae-dca0-4911-b256-73f48466d04c',NULL),('37a817de-c9a3-48cf-9b5a-1d9528eb42a9','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_create-client}','create-client','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('3e04f74b-d97b-4d0d-8683-66d987fceee3','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_realm-admin}','realm-admin','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('41b10923-3f04-4499-b032-63f96d5b0d36','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_view-clients}','view-clients','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('43a5ea3c-adb3-4e9d-86f0-2aa1131c4b61','f2da4c42-aebd-4280-a1b4-96186777b481',_binary '','${role_view-consent}','view-consent','master','f2da4c42-aebd-4280-a1b4-96186777b481',NULL),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','master',_binary '\0','${role_admin}','admin','master',NULL,NULL),('481478e3-16b7-41a9-a436-5c00e03f41ea','81532c06-1374-484f-98b7-099a30f05d3b',_binary '','${role_manage-account-links}','manage-account-links','premier','81532c06-1374-484f-98b7-099a30f05d3b',NULL),('482f7fbc-7c5f-46f1-b87f-49560ad83895','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_manage-events}','manage-events','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('486a91b4-5072-4c54-9273-0e4414d997be','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_query-users}','query-users','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('4a1c95f1-4427-4f75-8d3f-2c080d1cdfc4','master',_binary '\0','${role_uma_authorization}','uma_authorization','master',NULL,NULL),('4c1d179b-9bdd-4709-9337-8a93f80ab8c3','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_query-clients}','query-clients','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('4d141db3-35c0-44c4-8e11-e927bfc5b139','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_view-realm}','view-realm','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('51ed1905-7003-44aa-bec6-d3be7f8cecab','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_manage-events}','manage-events','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('5757278f-6b51-4ef6-91a3-535dca0e6c1d','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_view-events}','view-events','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('5cdd5173-0d68-4bc6-9e8d-9458fdeb84c2','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_manage-users}','manage-users','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('615ae9ab-29f0-4626-aef6-54b95ebacd6b','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_manage-realm}','manage-realm','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('62ff6819-70a2-40f0-ada1-d1ae01271c0d','81532c06-1374-484f-98b7-099a30f05d3b',_binary '','${role_view-profile}','view-profile','premier','81532c06-1374-484f-98b7-099a30f05d3b',NULL),('64c9b809-7224-446d-ae4c-73a4940290b1','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_manage-realm}','manage-realm','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('67faf19b-ae4f-4d7d-823f-556344919faa','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_query-realms}','query-realms','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('687373c8-6ab5-4967-bafd-28dd26369be3','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_manage-identity-providers}','manage-identity-providers','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('6c6ca9f0-6f57-4756-a720-9e7bea72a050','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_query-groups}','query-groups','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('6f893eb9-798b-4377-81a2-da3ebce7a372','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_impersonation}','impersonation','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('6fcd981b-a812-4039-84e8-2f50d5c7c229','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_manage-authorization}','manage-authorization','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('6fda947e-52fe-4235-81e9-0057137425fe','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_manage-authorization}','manage-authorization','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('71d9b96e-8d57-4e38-9334-dd448e22018b','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_view-clients}','view-clients','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('7267f896-bc9a-4d81-9d43-281f01a59875','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_view-events}','view-events','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('751fda26-6cf8-457a-957e-cf6a55cdfb71','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_view-users}','view-users','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('77477d4e-a150-4142-b064-5e193137c810','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_manage-users}','manage-users','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('79050af3-eea9-4d0b-886f-40f2bfad293d','master',_binary '\0','${role_offline-access}','offline_access','master',NULL,NULL),('81536380-4f39-45e2-bdf9-b8591feba9b0','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_manage-identity-providers}','manage-identity-providers','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('828e83ce-089f-462e-95c7-8456e5148243','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_view-authorization}','view-authorization','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('85e42549-455f-4d64-8fb8-b75a8cf1ac07','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_query-groups}','query-groups','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('87644370-208d-4c34-bdfe-e04b48a6f15d','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_view-identity-providers}','view-identity-providers','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('88ecd8a3-97e7-40f7-a9f1-4a6ffc2ed868','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_view-realm}','view-realm','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('895e4b86-ddea-4f9f-aac6-57681db472a5','master',_binary '\0','${role_create-realm}','create-realm','master',NULL,NULL),('89994a78-11b0-4355-88d6-8213a64241ed','f2da4c42-aebd-4280-a1b4-96186777b481',_binary '','${role_view-profile}','view-profile','master','f2da4c42-aebd-4280-a1b4-96186777b481',NULL),('8ae0b6da-3fdb-4e21-82a7-e19d09c728b4','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_query-users}','query-users','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('8b9bf70c-2e9d-4402-bac2-55dbca468cc6','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_manage-events}','manage-events','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('8cb575e4-4c35-416b-886d-ca98765e3ab0','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_query-users}','query-users','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('910bf3e0-473f-478a-b098-ac403beef797','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_manage-identity-providers}','manage-identity-providers','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('91b21f82-4682-4960-8e5f-1234288b96bd','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_query-clients}','query-clients','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('932550a5-e1c3-4cc9-afda-c2d927ca8e66','f2da4c42-aebd-4280-a1b4-96186777b481',_binary '','${role_view-applications}','view-applications','master','f2da4c42-aebd-4280-a1b4-96186777b481',NULL),('9b1aa55f-9891-4eac-a720-913b00b95b39','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_create-client}','create-client','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('9cbed7db-4882-4874-8a88-cfbe4573212a','81532c06-1374-484f-98b7-099a30f05d3b',_binary '','${role_manage-account}','manage-account','premier','81532c06-1374-484f-98b7-099a30f05d3b',NULL),('b2912c58-372c-4bb9-9bf6-326e37144ad4','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_manage-realm}','manage-realm','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('b526cd2a-450d-48a6-b3f7-62d52498a3fe','premier',_binary '\0','${role_offline-access}','offline_access','premier',NULL,NULL),('c0f03b74-0356-4c3b-a1bf-91503d91305b','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_view-events}','view-events','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('c13b5eaa-ed2d-42bc-820e-61e1ac9172b0','caee5346-2b08-4234-aaec-5a548db2fb62',_binary '','${role_read-token}','read-token','premier','caee5346-2b08-4234-aaec-5a548db2fb62',NULL),('c1d2f12e-4f4c-43f1-87c6-a31f1f416a97','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_query-groups}','query-groups','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('c3f9d5ca-bb6f-47d4-acd6-9d76fb180797','0c682461-637b-4fc9-a380-fb1ea4151528',_binary '','${role_manage-clients}','manage-clients','master','0c682461-637b-4fc9-a380-fb1ea4151528',NULL),('c8520bb0-032c-4f02-a627-e3f355545038','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_query-realms}','query-realms','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('cabc9dcb-e7a9-4965-a230-7eaaab60664e','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_manage-clients}','manage-clients','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('cc00e6f5-22aa-4125-9768-a64b73513d42','81532c06-1374-484f-98b7-099a30f05d3b',_binary '','${role_view-consent}','view-consent','premier','81532c06-1374-484f-98b7-099a30f05d3b',NULL),('ccf3a39e-16a6-4022-97e3-c84b4ff0e6d9','81532c06-1374-484f-98b7-099a30f05d3b',_binary '','${role_view-applications}','view-applications','premier','81532c06-1374-484f-98b7-099a30f05d3b',NULL),('cd4fc74c-da28-4fe8-80c4-5f98e88841fc','f2da4c42-aebd-4280-a1b4-96186777b481',_binary '','${role_delete-account}','delete-account','master','f2da4c42-aebd-4280-a1b4-96186777b481',NULL),('ce3c9dbc-c289-4a0f-8765-868190f39eef','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_impersonation}','impersonation','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('d1a3873f-98e0-40a9-857a-e8b7b0d13677','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_view-clients}','view-clients','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('d3914437-396b-4b4b-b24f-5f11c1ce039f','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_manage-clients}','manage-clients','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('da1f3d23-6e63-493d-932b-49b68e0ba6b1','premier',_binary '\0','${role_uma_authorization}','uma_authorization','premier',NULL,NULL),('dcf2e2bf-d666-437d-a392-d0729ae438d6','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_query-clients}','query-clients','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('e0d278f9-ea15-4ac5-8363-219d74ec1479','premier',_binary '\0','${role_default-roles}','default-roles-premier','premier',NULL,NULL),('e4b4a2d0-9aaf-467c-b07b-22738f14b3d1','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_manage-users}','manage-users','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('ea7058cc-e5c1-4634-ab32-dfe96596170d','73dcb78f-3531-43f9-8a08-d1a50ba33a95',_binary '','${role_manage-authorization}','manage-authorization','master','73dcb78f-3531-43f9-8a08-d1a50ba33a95',NULL),('ec13361c-8da3-4b45-aec8-7bf27af689e1','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_view-authorization}','view-authorization','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('f3891790-3438-478e-b56b-e85bfb9487e2','4759289b-1c4e-4c6c-b89e-376390812801',_binary '','${role_query-realms}','query-realms','premier','4759289b-1c4e-4c6c-b89e-376390812801',NULL),('fd3cef2e-47a3-4481-99f3-6721048d9b69','81532c06-1374-484f-98b7-099a30f05d3b',_binary '','${role_delete-account}','delete-account','premier','81532c06-1374-484f-98b7-099a30f05d3b',NULL),('fd908df2-b049-4e90-8db3-9506a0b692f8','81532c06-1374-484f-98b7-099a30f05d3b',_binary '','${role_manage-consent}','manage-consent','premier','81532c06-1374-484f-98b7-099a30f05d3b',NULL);
/*!40000 ALTER TABLE `KEYCLOAK_ROLE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MIGRATION_MODEL`
--

DROP TABLE IF EXISTS `MIGRATION_MODEL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MIGRATION_MODEL` (
  `ID` varchar(36) NOT NULL,
  `VERSION` varchar(36) DEFAULT NULL,
  `UPDATE_TIME` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `IDX_UPDATE_TIME` (`UPDATE_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MIGRATION_MODEL`
--

LOCK TABLES `MIGRATION_MODEL` WRITE;
/*!40000 ALTER TABLE `MIGRATION_MODEL` DISABLE KEYS */;
INSERT INTO `MIGRATION_MODEL` VALUES ('jfrty','16.1.0',1652619524);
/*!40000 ALTER TABLE `MIGRATION_MODEL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OFFLINE_CLIENT_SESSION`
--

DROP TABLE IF EXISTS `OFFLINE_CLIENT_SESSION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OFFLINE_CLIENT_SESSION` (
  `USER_SESSION_ID` varchar(36) NOT NULL,
  `CLIENT_ID` varchar(255) NOT NULL,
  `OFFLINE_FLAG` varchar(4) NOT NULL,
  `TIMESTAMP` int DEFAULT NULL,
  `DATA` longtext,
  `CLIENT_STORAGE_PROVIDER` varchar(36) NOT NULL DEFAULT 'local',
  `EXTERNAL_CLIENT_ID` varchar(255) NOT NULL DEFAULT 'local',
  PRIMARY KEY (`USER_SESSION_ID`,`CLIENT_ID`,`CLIENT_STORAGE_PROVIDER`,`EXTERNAL_CLIENT_ID`,`OFFLINE_FLAG`),
  KEY `IDX_US_SESS_ID_ON_CL_SESS` (`USER_SESSION_ID`),
  KEY `IDX_OFFLINE_CSS_PRELOAD` (`CLIENT_ID`,`OFFLINE_FLAG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OFFLINE_CLIENT_SESSION`
--

LOCK TABLES `OFFLINE_CLIENT_SESSION` WRITE;
/*!40000 ALTER TABLE `OFFLINE_CLIENT_SESSION` DISABLE KEYS */;
INSERT INTO `OFFLINE_CLIENT_SESSION` VALUES ('5becd785-5356-4feb-a920-31e1391fbe53','2daf2562-be27-4374-a8e5-ec3724e075a4','1',1652620277,'{\"authMethod\":\"openid-connect\",\"notes\":{\"iss\":\"http://localhost:8080/auth/realms/premier\",\"startedAt\":\"1652620277\",\"scope\":\"openid email profile offline_access\"}}','local','local');
/*!40000 ALTER TABLE `OFFLINE_CLIENT_SESSION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OFFLINE_USER_SESSION`
--

DROP TABLE IF EXISTS `OFFLINE_USER_SESSION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OFFLINE_USER_SESSION` (
  `USER_SESSION_ID` varchar(36) NOT NULL,
  `USER_ID` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  `CREATED_ON` int NOT NULL,
  `OFFLINE_FLAG` varchar(4) NOT NULL,
  `DATA` longtext,
  `LAST_SESSION_REFRESH` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`USER_SESSION_ID`,`OFFLINE_FLAG`),
  KEY `IDX_OFFLINE_USS_CREATEDON` (`CREATED_ON`),
  KEY `IDX_OFFLINE_USS_PRELOAD` (`OFFLINE_FLAG`,`CREATED_ON`,`USER_SESSION_ID`),
  KEY `IDX_OFFLINE_USS_BY_USER` (`USER_ID`,`REALM_ID`,`OFFLINE_FLAG`),
  KEY `IDX_OFFLINE_USS_BY_USERSESS` (`REALM_ID`,`OFFLINE_FLAG`,`USER_SESSION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OFFLINE_USER_SESSION`
--

LOCK TABLES `OFFLINE_USER_SESSION` WRITE;
/*!40000 ALTER TABLE `OFFLINE_USER_SESSION` DISABLE KEYS */;
INSERT INTO `OFFLINE_USER_SESSION` VALUES ('5becd785-5356-4feb-a920-31e1391fbe53','6dad8cd6-f02c-4c00-b54f-1d4f5a6046c9','premier',1652620277,'1','{\"ipAddress\":\"192.168.32.1\",\"authMethod\":\"openid-connect\",\"rememberMe\":false,\"started\":0,\"notes\":{\"KC_DEVICE_NOTE\":\"eyJpcEFkZHJlc3MiOiIxOTIuMTY4LjMyLjEiLCJvcyI6Ik90aGVyIiwib3NWZXJzaW9uIjoiVW5rbm93biIsImJyb3dzZXIiOiJPdGhlci9Vbmtub3duIiwiZGV2aWNlIjoiT3RoZXIiLCJsYXN0QWNjZXNzIjowLCJtb2JpbGUiOmZhbHNlfQ==\"},\"state\":\"LOGGED_IN\"}',1652620265);
/*!40000 ALTER TABLE `OFFLINE_USER_SESSION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `POLICY_CONFIG`
--

DROP TABLE IF EXISTS `POLICY_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `POLICY_CONFIG` (
  `POLICY_ID` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `VALUE` longtext,
  PRIMARY KEY (`POLICY_ID`,`NAME`),
  CONSTRAINT `FKDC34197CF864C4E43` FOREIGN KEY (`POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `POLICY_CONFIG`
--

LOCK TABLES `POLICY_CONFIG` WRITE;
/*!40000 ALTER TABLE `POLICY_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `POLICY_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROTOCOL_MAPPER`
--

DROP TABLE IF EXISTS `PROTOCOL_MAPPER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROTOCOL_MAPPER` (
  `ID` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `PROTOCOL` varchar(255) NOT NULL,
  `PROTOCOL_MAPPER_NAME` varchar(255) NOT NULL,
  `CLIENT_ID` varchar(36) DEFAULT NULL,
  `CLIENT_SCOPE_ID` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_PROTOCOL_MAPPER_CLIENT` (`CLIENT_ID`),
  KEY `IDX_CLSCOPE_PROTMAP` (`CLIENT_SCOPE_ID`),
  CONSTRAINT `FK_CLI_SCOPE_MAPPER` FOREIGN KEY (`CLIENT_SCOPE_ID`) REFERENCES `CLIENT_SCOPE` (`ID`),
  CONSTRAINT `FK_PCM_REALM` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROTOCOL_MAPPER`
--

LOCK TABLES `PROTOCOL_MAPPER` WRITE;
/*!40000 ALTER TABLE `PROTOCOL_MAPPER` DISABLE KEYS */;
INSERT INTO `PROTOCOL_MAPPER` VALUES ('011308f5-1312-4926-bfc6-70d09864b83e','allowed web origins','openid-connect','oidc-allowed-origins-mapper',NULL,'fa0593b6-5702-4790-b2b2-3b78c1bf4c5f'),('0332e4bb-9cbf-4b93-9161-8b63c573457a','username','openid-connect','oidc-usermodel-property-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('0aece976-cbf3-49ed-a7e9-3f24a5be3de7','middle name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('138590f4-f24c-4579-b31d-c3950871f606','username','openid-connect','oidc-usermodel-property-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('153be467-ae4a-48f6-9c3e-56c3a5e253fa','nickname','openid-connect','oidc-usermodel-attribute-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('243012d2-42e5-44fb-abe4-14b6d4ca2ce8','updated at','openid-connect','oidc-usermodel-attribute-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('2f951dba-1a36-4782-9483-a40aebf51eb0','gender','openid-connect','oidc-usermodel-attribute-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('324f5c34-e37f-4b22-b8a7-812596271618','upn','openid-connect','oidc-usermodel-property-mapper',NULL,'4ca73df8-9b1b-4095-933e-a725d4abf31a'),('34b12192-acab-45c3-932d-b75dfc0a9021','picture','openid-connect','oidc-usermodel-attribute-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('3d9da14d-62da-4170-91c2-6af61d805dcd','given name','openid-connect','oidc-usermodel-property-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('3e579ae2-88ef-4117-906c-8931f5f495a3','zoneinfo','openid-connect','oidc-usermodel-attribute-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('3edbca52-9b98-4995-ac18-ca2308435988','locale','openid-connect','oidc-usermodel-attribute-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('46c472b5-2026-4f8b-a378-ecbc0430e05f','phone number verified','openid-connect','oidc-usermodel-attribute-mapper',NULL,'e9106541-1d67-42b4-95c7-04c07d06c903'),('4876d65e-e1b7-499c-bdfb-9f9acba3496b','email verified','openid-connect','oidc-usermodel-property-mapper',NULL,'46a22422-7357-44f2-b7a2-c09757855ada'),('4a0998ee-6e49-45c9-be51-d784cc833b94','email verified','openid-connect','oidc-usermodel-property-mapper',NULL,'8ad5ab9f-7492-4752-bac7-8ff177e1d54e'),('4c678970-8ad9-4332-9849-1089ea5a8191','address','openid-connect','oidc-address-mapper',NULL,'59680041-0490-428f-a752-fa7af29388bb'),('4e2cb1ca-469c-4941-b2e8-de51812acaad','middle name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('51657321-12d0-42fc-af70-084cd83f0f7f','nickname','openid-connect','oidc-usermodel-attribute-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('63cb43f9-7730-4616-b68b-5d4ebb069e59','realm roles','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'ba614954-79b7-424b-a619-8a1f3bac41ba'),('64f270c5-487f-4591-898c-9ec7ae929e20','client roles','openid-connect','oidc-usermodel-client-role-mapper',NULL,'ba614954-79b7-424b-a619-8a1f3bac41ba'),('65368006-3f7b-4b57-b347-aec8d2945023','audience resolve','openid-connect','oidc-audience-resolve-mapper',NULL,'3de019da-3ffd-4a07-9cdb-8ad42a185ea2'),('67ef6745-d997-4692-9622-e916492096fd','allowed web origins','openid-connect','oidc-allowed-origins-mapper',NULL,'95d5c0ad-2f1e-4352-82f9-413423c761b6'),('689a6e39-e000-4d3d-a5cf-44a43311e28d','picture','openid-connect','oidc-usermodel-attribute-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('7777a4d9-2619-4d81-a51a-a3c004d2b0f0','birthdate','openid-connect','oidc-usermodel-attribute-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('7b4e1ab9-2620-4365-9765-b456c0441e05','phone number','openid-connect','oidc-usermodel-attribute-mapper',NULL,'e9106541-1d67-42b4-95c7-04c07d06c903'),('831af981-7a62-4075-961e-7f91cbf55ad8','groups','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'9db15b72-b3ed-45b9-bb2e-eacb41208941'),('839072e7-d788-49a9-8185-098b74109a7a','realm roles','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'3de019da-3ffd-4a07-9cdb-8ad42a185ea2'),('9295057f-93fc-4950-b64e-4347c41748ea','full name','openid-connect','oidc-full-name-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('94b81cd2-5a6b-4355-a580-117c44f5315c','client roles','openid-connect','oidc-usermodel-client-role-mapper',NULL,'3de019da-3ffd-4a07-9cdb-8ad42a185ea2'),('965d8efb-e269-4f03-a92a-e66d980dd835','locale','openid-connect','oidc-usermodel-attribute-mapper','cb82b8af-9a08-4467-930c-6fd317b867ba',NULL),('9a17ecb9-27b8-4079-82e6-42e297e4bbf3','zoneinfo','openid-connect','oidc-usermodel-attribute-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('a70afb8d-edd9-4f64-8a83-fd9b86402ae0','address','openid-connect','oidc-address-mapper',NULL,'8f98f9e9-29c7-4353-8944-1efc25c0ee38'),('a76c0e05-746b-4fe5-81f1-1899db7d331c','birthdate','openid-connect','oidc-usermodel-attribute-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('b2ae67ee-f645-4ccb-ad0e-83fd1c8c2c31','family name','openid-connect','oidc-usermodel-property-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('b80342e5-fbb8-46d4-a688-f83e089a9c7f','upn','openid-connect','oidc-usermodel-property-mapper',NULL,'9db15b72-b3ed-45b9-bb2e-eacb41208941'),('bc35a721-d0ad-46d7-ba39-8b788b7a2a75','updated at','openid-connect','oidc-usermodel-attribute-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('c1b72a2d-b196-4cd0-a51e-ce0bfc112cf0','locale','openid-connect','oidc-usermodel-attribute-mapper','11ffd935-73b8-4ec7-a5ca-676c0b237009',NULL),('c27959cb-38e1-417f-9150-518474db6e86','locale','openid-connect','oidc-usermodel-attribute-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('c5abdc99-f91d-4890-8592-b9c1b0d3e349','audience resolve','openid-connect','oidc-audience-resolve-mapper','fbcb07a8-8e18-4879-a845-6c164ea7452e',NULL),('c666b9d9-cae3-43b2-ad72-08be3f0f4191','groups','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'4ca73df8-9b1b-4095-933e-a725d4abf31a'),('c710d50c-ebbb-4fca-97d4-d252a9a9e143','email','openid-connect','oidc-usermodel-property-mapper',NULL,'8ad5ab9f-7492-4752-bac7-8ff177e1d54e'),('d2361ec3-9426-41f5-ab8e-f9f7f6b526f4','gender','openid-connect','oidc-usermodel-attribute-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('d2c731ff-98f4-488d-99cf-ddba9a2abc80','website','openid-connect','oidc-usermodel-attribute-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('d6374a70-01ce-4492-9160-55924a084fee','website','openid-connect','oidc-usermodel-attribute-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('d7499d1d-80ed-45fd-894f-c07dc726a69f','role list','saml','saml-role-list-mapper',NULL,'1b8b705a-46a0-401a-b3fe-5bdc0f8bed62'),('dca0de6e-830b-4729-b018-22db0bc5ad75','email','openid-connect','oidc-usermodel-property-mapper',NULL,'46a22422-7357-44f2-b7a2-c09757855ada'),('de267f0d-63ca-4d5e-ba9e-f1b0ad206215','audience resolve','openid-connect','oidc-audience-resolve-mapper',NULL,'ba614954-79b7-424b-a619-8a1f3bac41ba'),('de3c4f9c-e3cf-4b4f-a0f4-90035eae268d','audience resolve','openid-connect','oidc-audience-resolve-mapper','cad92466-0a1a-4c35-b1fc-54343980c330',NULL),('dff446b8-38ae-4802-af44-5f513d2095aa','profile','openid-connect','oidc-usermodel-attribute-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('e2f7e3df-59d1-4c7d-9dae-397e452499e0','profile','openid-connect','oidc-usermodel-attribute-mapper',NULL,'73a2d837-3a42-4133-908e-ca54e2f29677'),('e6cc27c6-7df7-409b-8fa8-ec813a26dec1','role list','saml','saml-role-list-mapper',NULL,'cc333c37-309e-4b46-b1be-b61953eb5180'),('e971d992-099d-4895-b70f-25e897a75545','given name','openid-connect','oidc-usermodel-property-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('eab7ad20-44fe-45c3-a5b6-ff8a23564f4c','full name','openid-connect','oidc-full-name-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7'),('ed771b0b-d3c5-4c61-8fab-75f0e91535f7','phone number verified','openid-connect','oidc-usermodel-attribute-mapper',NULL,'d0fd93f7-9c0c-47d5-b15b-e6528c90a942'),('f8a92b71-d196-4055-8708-6fe278768773','phone number','openid-connect','oidc-usermodel-attribute-mapper',NULL,'d0fd93f7-9c0c-47d5-b15b-e6528c90a942'),('ffecf508-cbaa-47c9-ae1a-fe2ac8ab450e','family name','openid-connect','oidc-usermodel-property-mapper',NULL,'260bb8f9-c0c3-43a5-acf4-07c78bd3fca7');
/*!40000 ALTER TABLE `PROTOCOL_MAPPER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROTOCOL_MAPPER_CONFIG`
--

DROP TABLE IF EXISTS `PROTOCOL_MAPPER_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROTOCOL_MAPPER_CONFIG` (
  `PROTOCOL_MAPPER_ID` varchar(36) NOT NULL,
  `VALUE` longtext,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`PROTOCOL_MAPPER_ID`,`NAME`),
  CONSTRAINT `FK_PMCONFIG` FOREIGN KEY (`PROTOCOL_MAPPER_ID`) REFERENCES `PROTOCOL_MAPPER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROTOCOL_MAPPER_CONFIG`
--

LOCK TABLES `PROTOCOL_MAPPER_CONFIG` WRITE;
/*!40000 ALTER TABLE `PROTOCOL_MAPPER_CONFIG` DISABLE KEYS */;
INSERT INTO `PROTOCOL_MAPPER_CONFIG` VALUES ('0332e4bb-9cbf-4b93-9161-8b63c573457a','true','access.token.claim'),('0332e4bb-9cbf-4b93-9161-8b63c573457a','preferred_username','claim.name'),('0332e4bb-9cbf-4b93-9161-8b63c573457a','true','id.token.claim'),('0332e4bb-9cbf-4b93-9161-8b63c573457a','String','jsonType.label'),('0332e4bb-9cbf-4b93-9161-8b63c573457a','username','user.attribute'),('0332e4bb-9cbf-4b93-9161-8b63c573457a','true','userinfo.token.claim'),('0aece976-cbf3-49ed-a7e9-3f24a5be3de7','true','access.token.claim'),('0aece976-cbf3-49ed-a7e9-3f24a5be3de7','middle_name','claim.name'),('0aece976-cbf3-49ed-a7e9-3f24a5be3de7','true','id.token.claim'),('0aece976-cbf3-49ed-a7e9-3f24a5be3de7','String','jsonType.label'),('0aece976-cbf3-49ed-a7e9-3f24a5be3de7','middleName','user.attribute'),('0aece976-cbf3-49ed-a7e9-3f24a5be3de7','true','userinfo.token.claim'),('138590f4-f24c-4579-b31d-c3950871f606','true','access.token.claim'),('138590f4-f24c-4579-b31d-c3950871f606','preferred_username','claim.name'),('138590f4-f24c-4579-b31d-c3950871f606','true','id.token.claim'),('138590f4-f24c-4579-b31d-c3950871f606','String','jsonType.label'),('138590f4-f24c-4579-b31d-c3950871f606','username','user.attribute'),('138590f4-f24c-4579-b31d-c3950871f606','true','userinfo.token.claim'),('153be467-ae4a-48f6-9c3e-56c3a5e253fa','true','access.token.claim'),('153be467-ae4a-48f6-9c3e-56c3a5e253fa','nickname','claim.name'),('153be467-ae4a-48f6-9c3e-56c3a5e253fa','true','id.token.claim'),('153be467-ae4a-48f6-9c3e-56c3a5e253fa','String','jsonType.label'),('153be467-ae4a-48f6-9c3e-56c3a5e253fa','nickname','user.attribute'),('153be467-ae4a-48f6-9c3e-56c3a5e253fa','true','userinfo.token.claim'),('243012d2-42e5-44fb-abe4-14b6d4ca2ce8','true','access.token.claim'),('243012d2-42e5-44fb-abe4-14b6d4ca2ce8','updated_at','claim.name'),('243012d2-42e5-44fb-abe4-14b6d4ca2ce8','true','id.token.claim'),('243012d2-42e5-44fb-abe4-14b6d4ca2ce8','String','jsonType.label'),('243012d2-42e5-44fb-abe4-14b6d4ca2ce8','updatedAt','user.attribute'),('243012d2-42e5-44fb-abe4-14b6d4ca2ce8','true','userinfo.token.claim'),('2f951dba-1a36-4782-9483-a40aebf51eb0','true','access.token.claim'),('2f951dba-1a36-4782-9483-a40aebf51eb0','gender','claim.name'),('2f951dba-1a36-4782-9483-a40aebf51eb0','true','id.token.claim'),('2f951dba-1a36-4782-9483-a40aebf51eb0','String','jsonType.label'),('2f951dba-1a36-4782-9483-a40aebf51eb0','gender','user.attribute'),('2f951dba-1a36-4782-9483-a40aebf51eb0','true','userinfo.token.claim'),('324f5c34-e37f-4b22-b8a7-812596271618','true','access.token.claim'),('324f5c34-e37f-4b22-b8a7-812596271618','upn','claim.name'),('324f5c34-e37f-4b22-b8a7-812596271618','true','id.token.claim'),('324f5c34-e37f-4b22-b8a7-812596271618','String','jsonType.label'),('324f5c34-e37f-4b22-b8a7-812596271618','username','user.attribute'),('324f5c34-e37f-4b22-b8a7-812596271618','true','userinfo.token.claim'),('34b12192-acab-45c3-932d-b75dfc0a9021','true','access.token.claim'),('34b12192-acab-45c3-932d-b75dfc0a9021','picture','claim.name'),('34b12192-acab-45c3-932d-b75dfc0a9021','true','id.token.claim'),('34b12192-acab-45c3-932d-b75dfc0a9021','String','jsonType.label'),('34b12192-acab-45c3-932d-b75dfc0a9021','picture','user.attribute'),('34b12192-acab-45c3-932d-b75dfc0a9021','true','userinfo.token.claim'),('3d9da14d-62da-4170-91c2-6af61d805dcd','true','access.token.claim'),('3d9da14d-62da-4170-91c2-6af61d805dcd','given_name','claim.name'),('3d9da14d-62da-4170-91c2-6af61d805dcd','true','id.token.claim'),('3d9da14d-62da-4170-91c2-6af61d805dcd','String','jsonType.label'),('3d9da14d-62da-4170-91c2-6af61d805dcd','firstName','user.attribute'),('3d9da14d-62da-4170-91c2-6af61d805dcd','true','userinfo.token.claim'),('3e579ae2-88ef-4117-906c-8931f5f495a3','true','access.token.claim'),('3e579ae2-88ef-4117-906c-8931f5f495a3','zoneinfo','claim.name'),('3e579ae2-88ef-4117-906c-8931f5f495a3','true','id.token.claim'),('3e579ae2-88ef-4117-906c-8931f5f495a3','String','jsonType.label'),('3e579ae2-88ef-4117-906c-8931f5f495a3','zoneinfo','user.attribute'),('3e579ae2-88ef-4117-906c-8931f5f495a3','true','userinfo.token.claim'),('3edbca52-9b98-4995-ac18-ca2308435988','true','access.token.claim'),('3edbca52-9b98-4995-ac18-ca2308435988','locale','claim.name'),('3edbca52-9b98-4995-ac18-ca2308435988','true','id.token.claim'),('3edbca52-9b98-4995-ac18-ca2308435988','String','jsonType.label'),('3edbca52-9b98-4995-ac18-ca2308435988','locale','user.attribute'),('3edbca52-9b98-4995-ac18-ca2308435988','true','userinfo.token.claim'),('46c472b5-2026-4f8b-a378-ecbc0430e05f','true','access.token.claim'),('46c472b5-2026-4f8b-a378-ecbc0430e05f','phone_number_verified','claim.name'),('46c472b5-2026-4f8b-a378-ecbc0430e05f','true','id.token.claim'),('46c472b5-2026-4f8b-a378-ecbc0430e05f','boolean','jsonType.label'),('46c472b5-2026-4f8b-a378-ecbc0430e05f','phoneNumberVerified','user.attribute'),('46c472b5-2026-4f8b-a378-ecbc0430e05f','true','userinfo.token.claim'),('4876d65e-e1b7-499c-bdfb-9f9acba3496b','true','access.token.claim'),('4876d65e-e1b7-499c-bdfb-9f9acba3496b','email_verified','claim.name'),('4876d65e-e1b7-499c-bdfb-9f9acba3496b','true','id.token.claim'),('4876d65e-e1b7-499c-bdfb-9f9acba3496b','boolean','jsonType.label'),('4876d65e-e1b7-499c-bdfb-9f9acba3496b','emailVerified','user.attribute'),('4876d65e-e1b7-499c-bdfb-9f9acba3496b','true','userinfo.token.claim'),('4a0998ee-6e49-45c9-be51-d784cc833b94','true','access.token.claim'),('4a0998ee-6e49-45c9-be51-d784cc833b94','email_verified','claim.name'),('4a0998ee-6e49-45c9-be51-d784cc833b94','true','id.token.claim'),('4a0998ee-6e49-45c9-be51-d784cc833b94','boolean','jsonType.label'),('4a0998ee-6e49-45c9-be51-d784cc833b94','emailVerified','user.attribute'),('4a0998ee-6e49-45c9-be51-d784cc833b94','true','userinfo.token.claim'),('4c678970-8ad9-4332-9849-1089ea5a8191','true','access.token.claim'),('4c678970-8ad9-4332-9849-1089ea5a8191','true','id.token.claim'),('4c678970-8ad9-4332-9849-1089ea5a8191','country','user.attribute.country'),('4c678970-8ad9-4332-9849-1089ea5a8191','formatted','user.attribute.formatted'),('4c678970-8ad9-4332-9849-1089ea5a8191','locality','user.attribute.locality'),('4c678970-8ad9-4332-9849-1089ea5a8191','postal_code','user.attribute.postal_code'),('4c678970-8ad9-4332-9849-1089ea5a8191','region','user.attribute.region'),('4c678970-8ad9-4332-9849-1089ea5a8191','street','user.attribute.street'),('4c678970-8ad9-4332-9849-1089ea5a8191','true','userinfo.token.claim'),('4e2cb1ca-469c-4941-b2e8-de51812acaad','true','access.token.claim'),('4e2cb1ca-469c-4941-b2e8-de51812acaad','middle_name','claim.name'),('4e2cb1ca-469c-4941-b2e8-de51812acaad','true','id.token.claim'),('4e2cb1ca-469c-4941-b2e8-de51812acaad','String','jsonType.label'),('4e2cb1ca-469c-4941-b2e8-de51812acaad','middleName','user.attribute'),('4e2cb1ca-469c-4941-b2e8-de51812acaad','true','userinfo.token.claim'),('51657321-12d0-42fc-af70-084cd83f0f7f','true','access.token.claim'),('51657321-12d0-42fc-af70-084cd83f0f7f','nickname','claim.name'),('51657321-12d0-42fc-af70-084cd83f0f7f','true','id.token.claim'),('51657321-12d0-42fc-af70-084cd83f0f7f','String','jsonType.label'),('51657321-12d0-42fc-af70-084cd83f0f7f','nickname','user.attribute'),('51657321-12d0-42fc-af70-084cd83f0f7f','true','userinfo.token.claim'),('63cb43f9-7730-4616-b68b-5d4ebb069e59','true','access.token.claim'),('63cb43f9-7730-4616-b68b-5d4ebb069e59','realm_access.roles','claim.name'),('63cb43f9-7730-4616-b68b-5d4ebb069e59','String','jsonType.label'),('63cb43f9-7730-4616-b68b-5d4ebb069e59','true','multivalued'),('63cb43f9-7730-4616-b68b-5d4ebb069e59','foo','user.attribute'),('64f270c5-487f-4591-898c-9ec7ae929e20','true','access.token.claim'),('64f270c5-487f-4591-898c-9ec7ae929e20','resource_access.${client_id}.roles','claim.name'),('64f270c5-487f-4591-898c-9ec7ae929e20','String','jsonType.label'),('64f270c5-487f-4591-898c-9ec7ae929e20','true','multivalued'),('64f270c5-487f-4591-898c-9ec7ae929e20','foo','user.attribute'),('689a6e39-e000-4d3d-a5cf-44a43311e28d','true','access.token.claim'),('689a6e39-e000-4d3d-a5cf-44a43311e28d','picture','claim.name'),('689a6e39-e000-4d3d-a5cf-44a43311e28d','true','id.token.claim'),('689a6e39-e000-4d3d-a5cf-44a43311e28d','String','jsonType.label'),('689a6e39-e000-4d3d-a5cf-44a43311e28d','picture','user.attribute'),('689a6e39-e000-4d3d-a5cf-44a43311e28d','true','userinfo.token.claim'),('7777a4d9-2619-4d81-a51a-a3c004d2b0f0','true','access.token.claim'),('7777a4d9-2619-4d81-a51a-a3c004d2b0f0','birthdate','claim.name'),('7777a4d9-2619-4d81-a51a-a3c004d2b0f0','true','id.token.claim'),('7777a4d9-2619-4d81-a51a-a3c004d2b0f0','String','jsonType.label'),('7777a4d9-2619-4d81-a51a-a3c004d2b0f0','birthdate','user.attribute'),('7777a4d9-2619-4d81-a51a-a3c004d2b0f0','true','userinfo.token.claim'),('7b4e1ab9-2620-4365-9765-b456c0441e05','true','access.token.claim'),('7b4e1ab9-2620-4365-9765-b456c0441e05','phone_number','claim.name'),('7b4e1ab9-2620-4365-9765-b456c0441e05','true','id.token.claim'),('7b4e1ab9-2620-4365-9765-b456c0441e05','String','jsonType.label'),('7b4e1ab9-2620-4365-9765-b456c0441e05','phoneNumber','user.attribute'),('7b4e1ab9-2620-4365-9765-b456c0441e05','true','userinfo.token.claim'),('831af981-7a62-4075-961e-7f91cbf55ad8','true','access.token.claim'),('831af981-7a62-4075-961e-7f91cbf55ad8','groups','claim.name'),('831af981-7a62-4075-961e-7f91cbf55ad8','true','id.token.claim'),('831af981-7a62-4075-961e-7f91cbf55ad8','String','jsonType.label'),('831af981-7a62-4075-961e-7f91cbf55ad8','true','multivalued'),('831af981-7a62-4075-961e-7f91cbf55ad8','foo','user.attribute'),('839072e7-d788-49a9-8185-098b74109a7a','true','access.token.claim'),('839072e7-d788-49a9-8185-098b74109a7a','realm_access.roles','claim.name'),('839072e7-d788-49a9-8185-098b74109a7a','String','jsonType.label'),('839072e7-d788-49a9-8185-098b74109a7a','true','multivalued'),('839072e7-d788-49a9-8185-098b74109a7a','foo','user.attribute'),('9295057f-93fc-4950-b64e-4347c41748ea','true','access.token.claim'),('9295057f-93fc-4950-b64e-4347c41748ea','true','id.token.claim'),('9295057f-93fc-4950-b64e-4347c41748ea','true','userinfo.token.claim'),('94b81cd2-5a6b-4355-a580-117c44f5315c','true','access.token.claim'),('94b81cd2-5a6b-4355-a580-117c44f5315c','resource_access.${client_id}.roles','claim.name'),('94b81cd2-5a6b-4355-a580-117c44f5315c','String','jsonType.label'),('94b81cd2-5a6b-4355-a580-117c44f5315c','true','multivalued'),('94b81cd2-5a6b-4355-a580-117c44f5315c','foo','user.attribute'),('965d8efb-e269-4f03-a92a-e66d980dd835','true','access.token.claim'),('965d8efb-e269-4f03-a92a-e66d980dd835','locale','claim.name'),('965d8efb-e269-4f03-a92a-e66d980dd835','true','id.token.claim'),('965d8efb-e269-4f03-a92a-e66d980dd835','String','jsonType.label'),('965d8efb-e269-4f03-a92a-e66d980dd835','locale','user.attribute'),('965d8efb-e269-4f03-a92a-e66d980dd835','true','userinfo.token.claim'),('9a17ecb9-27b8-4079-82e6-42e297e4bbf3','true','access.token.claim'),('9a17ecb9-27b8-4079-82e6-42e297e4bbf3','zoneinfo','claim.name'),('9a17ecb9-27b8-4079-82e6-42e297e4bbf3','true','id.token.claim'),('9a17ecb9-27b8-4079-82e6-42e297e4bbf3','String','jsonType.label'),('9a17ecb9-27b8-4079-82e6-42e297e4bbf3','zoneinfo','user.attribute'),('9a17ecb9-27b8-4079-82e6-42e297e4bbf3','true','userinfo.token.claim'),('a70afb8d-edd9-4f64-8a83-fd9b86402ae0','true','access.token.claim'),('a70afb8d-edd9-4f64-8a83-fd9b86402ae0','true','id.token.claim'),('a70afb8d-edd9-4f64-8a83-fd9b86402ae0','country','user.attribute.country'),('a70afb8d-edd9-4f64-8a83-fd9b86402ae0','formatted','user.attribute.formatted'),('a70afb8d-edd9-4f64-8a83-fd9b86402ae0','locality','user.attribute.locality'),('a70afb8d-edd9-4f64-8a83-fd9b86402ae0','postal_code','user.attribute.postal_code'),('a70afb8d-edd9-4f64-8a83-fd9b86402ae0','region','user.attribute.region'),('a70afb8d-edd9-4f64-8a83-fd9b86402ae0','street','user.attribute.street'),('a70afb8d-edd9-4f64-8a83-fd9b86402ae0','true','userinfo.token.claim'),('a76c0e05-746b-4fe5-81f1-1899db7d331c','true','access.token.claim'),('a76c0e05-746b-4fe5-81f1-1899db7d331c','birthdate','claim.name'),('a76c0e05-746b-4fe5-81f1-1899db7d331c','true','id.token.claim'),('a76c0e05-746b-4fe5-81f1-1899db7d331c','String','jsonType.label'),('a76c0e05-746b-4fe5-81f1-1899db7d331c','birthdate','user.attribute'),('a76c0e05-746b-4fe5-81f1-1899db7d331c','true','userinfo.token.claim'),('b2ae67ee-f645-4ccb-ad0e-83fd1c8c2c31','true','access.token.claim'),('b2ae67ee-f645-4ccb-ad0e-83fd1c8c2c31','family_name','claim.name'),('b2ae67ee-f645-4ccb-ad0e-83fd1c8c2c31','true','id.token.claim'),('b2ae67ee-f645-4ccb-ad0e-83fd1c8c2c31','String','jsonType.label'),('b2ae67ee-f645-4ccb-ad0e-83fd1c8c2c31','lastName','user.attribute'),('b2ae67ee-f645-4ccb-ad0e-83fd1c8c2c31','true','userinfo.token.claim'),('b80342e5-fbb8-46d4-a688-f83e089a9c7f','true','access.token.claim'),('b80342e5-fbb8-46d4-a688-f83e089a9c7f','upn','claim.name'),('b80342e5-fbb8-46d4-a688-f83e089a9c7f','true','id.token.claim'),('b80342e5-fbb8-46d4-a688-f83e089a9c7f','String','jsonType.label'),('b80342e5-fbb8-46d4-a688-f83e089a9c7f','username','user.attribute'),('b80342e5-fbb8-46d4-a688-f83e089a9c7f','true','userinfo.token.claim'),('bc35a721-d0ad-46d7-ba39-8b788b7a2a75','true','access.token.claim'),('bc35a721-d0ad-46d7-ba39-8b788b7a2a75','updated_at','claim.name'),('bc35a721-d0ad-46d7-ba39-8b788b7a2a75','true','id.token.claim'),('bc35a721-d0ad-46d7-ba39-8b788b7a2a75','String','jsonType.label'),('bc35a721-d0ad-46d7-ba39-8b788b7a2a75','updatedAt','user.attribute'),('bc35a721-d0ad-46d7-ba39-8b788b7a2a75','true','userinfo.token.claim'),('c1b72a2d-b196-4cd0-a51e-ce0bfc112cf0','true','access.token.claim'),('c1b72a2d-b196-4cd0-a51e-ce0bfc112cf0','locale','claim.name'),('c1b72a2d-b196-4cd0-a51e-ce0bfc112cf0','true','id.token.claim'),('c1b72a2d-b196-4cd0-a51e-ce0bfc112cf0','String','jsonType.label'),('c1b72a2d-b196-4cd0-a51e-ce0bfc112cf0','locale','user.attribute'),('c1b72a2d-b196-4cd0-a51e-ce0bfc112cf0','true','userinfo.token.claim'),('c27959cb-38e1-417f-9150-518474db6e86','true','access.token.claim'),('c27959cb-38e1-417f-9150-518474db6e86','locale','claim.name'),('c27959cb-38e1-417f-9150-518474db6e86','true','id.token.claim'),('c27959cb-38e1-417f-9150-518474db6e86','String','jsonType.label'),('c27959cb-38e1-417f-9150-518474db6e86','locale','user.attribute'),('c27959cb-38e1-417f-9150-518474db6e86','true','userinfo.token.claim'),('c666b9d9-cae3-43b2-ad72-08be3f0f4191','true','access.token.claim'),('c666b9d9-cae3-43b2-ad72-08be3f0f4191','groups','claim.name'),('c666b9d9-cae3-43b2-ad72-08be3f0f4191','true','id.token.claim'),('c666b9d9-cae3-43b2-ad72-08be3f0f4191','String','jsonType.label'),('c666b9d9-cae3-43b2-ad72-08be3f0f4191','true','multivalued'),('c666b9d9-cae3-43b2-ad72-08be3f0f4191','foo','user.attribute'),('c710d50c-ebbb-4fca-97d4-d252a9a9e143','true','access.token.claim'),('c710d50c-ebbb-4fca-97d4-d252a9a9e143','email','claim.name'),('c710d50c-ebbb-4fca-97d4-d252a9a9e143','true','id.token.claim'),('c710d50c-ebbb-4fca-97d4-d252a9a9e143','String','jsonType.label'),('c710d50c-ebbb-4fca-97d4-d252a9a9e143','email','user.attribute'),('c710d50c-ebbb-4fca-97d4-d252a9a9e143','true','userinfo.token.claim'),('d2361ec3-9426-41f5-ab8e-f9f7f6b526f4','true','access.token.claim'),('d2361ec3-9426-41f5-ab8e-f9f7f6b526f4','gender','claim.name'),('d2361ec3-9426-41f5-ab8e-f9f7f6b526f4','true','id.token.claim'),('d2361ec3-9426-41f5-ab8e-f9f7f6b526f4','String','jsonType.label'),('d2361ec3-9426-41f5-ab8e-f9f7f6b526f4','gender','user.attribute'),('d2361ec3-9426-41f5-ab8e-f9f7f6b526f4','true','userinfo.token.claim'),('d2c731ff-98f4-488d-99cf-ddba9a2abc80','true','access.token.claim'),('d2c731ff-98f4-488d-99cf-ddba9a2abc80','website','claim.name'),('d2c731ff-98f4-488d-99cf-ddba9a2abc80','true','id.token.claim'),('d2c731ff-98f4-488d-99cf-ddba9a2abc80','String','jsonType.label'),('d2c731ff-98f4-488d-99cf-ddba9a2abc80','website','user.attribute'),('d2c731ff-98f4-488d-99cf-ddba9a2abc80','true','userinfo.token.claim'),('d6374a70-01ce-4492-9160-55924a084fee','true','access.token.claim'),('d6374a70-01ce-4492-9160-55924a084fee','website','claim.name'),('d6374a70-01ce-4492-9160-55924a084fee','true','id.token.claim'),('d6374a70-01ce-4492-9160-55924a084fee','String','jsonType.label'),('d6374a70-01ce-4492-9160-55924a084fee','website','user.attribute'),('d6374a70-01ce-4492-9160-55924a084fee','true','userinfo.token.claim'),('d7499d1d-80ed-45fd-894f-c07dc726a69f','Role','attribute.name'),('d7499d1d-80ed-45fd-894f-c07dc726a69f','Basic','attribute.nameformat'),('d7499d1d-80ed-45fd-894f-c07dc726a69f','false','single'),('dca0de6e-830b-4729-b018-22db0bc5ad75','true','access.token.claim'),('dca0de6e-830b-4729-b018-22db0bc5ad75','email','claim.name'),('dca0de6e-830b-4729-b018-22db0bc5ad75','true','id.token.claim'),('dca0de6e-830b-4729-b018-22db0bc5ad75','String','jsonType.label'),('dca0de6e-830b-4729-b018-22db0bc5ad75','email','user.attribute'),('dca0de6e-830b-4729-b018-22db0bc5ad75','true','userinfo.token.claim'),('dff446b8-38ae-4802-af44-5f513d2095aa','true','access.token.claim'),('dff446b8-38ae-4802-af44-5f513d2095aa','profile','claim.name'),('dff446b8-38ae-4802-af44-5f513d2095aa','true','id.token.claim'),('dff446b8-38ae-4802-af44-5f513d2095aa','String','jsonType.label'),('dff446b8-38ae-4802-af44-5f513d2095aa','profile','user.attribute'),('dff446b8-38ae-4802-af44-5f513d2095aa','true','userinfo.token.claim'),('e2f7e3df-59d1-4c7d-9dae-397e452499e0','true','access.token.claim'),('e2f7e3df-59d1-4c7d-9dae-397e452499e0','profile','claim.name'),('e2f7e3df-59d1-4c7d-9dae-397e452499e0','true','id.token.claim'),('e2f7e3df-59d1-4c7d-9dae-397e452499e0','String','jsonType.label'),('e2f7e3df-59d1-4c7d-9dae-397e452499e0','profile','user.attribute'),('e2f7e3df-59d1-4c7d-9dae-397e452499e0','true','userinfo.token.claim'),('e6cc27c6-7df7-409b-8fa8-ec813a26dec1','Role','attribute.name'),('e6cc27c6-7df7-409b-8fa8-ec813a26dec1','Basic','attribute.nameformat'),('e6cc27c6-7df7-409b-8fa8-ec813a26dec1','false','single'),('e971d992-099d-4895-b70f-25e897a75545','true','access.token.claim'),('e971d992-099d-4895-b70f-25e897a75545','given_name','claim.name'),('e971d992-099d-4895-b70f-25e897a75545','true','id.token.claim'),('e971d992-099d-4895-b70f-25e897a75545','String','jsonType.label'),('e971d992-099d-4895-b70f-25e897a75545','firstName','user.attribute'),('e971d992-099d-4895-b70f-25e897a75545','true','userinfo.token.claim'),('eab7ad20-44fe-45c3-a5b6-ff8a23564f4c','true','access.token.claim'),('eab7ad20-44fe-45c3-a5b6-ff8a23564f4c','true','id.token.claim'),('eab7ad20-44fe-45c3-a5b6-ff8a23564f4c','true','userinfo.token.claim'),('ed771b0b-d3c5-4c61-8fab-75f0e91535f7','true','access.token.claim'),('ed771b0b-d3c5-4c61-8fab-75f0e91535f7','phone_number_verified','claim.name'),('ed771b0b-d3c5-4c61-8fab-75f0e91535f7','true','id.token.claim'),('ed771b0b-d3c5-4c61-8fab-75f0e91535f7','boolean','jsonType.label'),('ed771b0b-d3c5-4c61-8fab-75f0e91535f7','phoneNumberVerified','user.attribute'),('ed771b0b-d3c5-4c61-8fab-75f0e91535f7','true','userinfo.token.claim'),('f8a92b71-d196-4055-8708-6fe278768773','true','access.token.claim'),('f8a92b71-d196-4055-8708-6fe278768773','phone_number','claim.name'),('f8a92b71-d196-4055-8708-6fe278768773','true','id.token.claim'),('f8a92b71-d196-4055-8708-6fe278768773','String','jsonType.label'),('f8a92b71-d196-4055-8708-6fe278768773','phoneNumber','user.attribute'),('f8a92b71-d196-4055-8708-6fe278768773','true','userinfo.token.claim'),('ffecf508-cbaa-47c9-ae1a-fe2ac8ab450e','true','access.token.claim'),('ffecf508-cbaa-47c9-ae1a-fe2ac8ab450e','family_name','claim.name'),('ffecf508-cbaa-47c9-ae1a-fe2ac8ab450e','true','id.token.claim'),('ffecf508-cbaa-47c9-ae1a-fe2ac8ab450e','String','jsonType.label'),('ffecf508-cbaa-47c9-ae1a-fe2ac8ab450e','lastName','user.attribute'),('ffecf508-cbaa-47c9-ae1a-fe2ac8ab450e','true','userinfo.token.claim');
/*!40000 ALTER TABLE `PROTOCOL_MAPPER_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM`
--

DROP TABLE IF EXISTS `REALM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM` (
  `ID` varchar(36) NOT NULL,
  `ACCESS_CODE_LIFESPAN` int DEFAULT NULL,
  `USER_ACTION_LIFESPAN` int DEFAULT NULL,
  `ACCESS_TOKEN_LIFESPAN` int DEFAULT NULL,
  `ACCOUNT_THEME` varchar(255) DEFAULT NULL,
  `ADMIN_THEME` varchar(255) DEFAULT NULL,
  `EMAIL_THEME` varchar(255) DEFAULT NULL,
  `ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `EVENTS_ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `EVENTS_EXPIRATION` bigint DEFAULT NULL,
  `LOGIN_THEME` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `NOT_BEFORE` int DEFAULT NULL,
  `PASSWORD_POLICY` text,
  `REGISTRATION_ALLOWED` bit(1) NOT NULL DEFAULT b'0',
  `REMEMBER_ME` bit(1) NOT NULL DEFAULT b'0',
  `RESET_PASSWORD_ALLOWED` bit(1) NOT NULL DEFAULT b'0',
  `SOCIAL` bit(1) NOT NULL DEFAULT b'0',
  `SSL_REQUIRED` varchar(255) DEFAULT NULL,
  `SSO_IDLE_TIMEOUT` int DEFAULT NULL,
  `SSO_MAX_LIFESPAN` int DEFAULT NULL,
  `UPDATE_PROFILE_ON_SOC_LOGIN` bit(1) NOT NULL DEFAULT b'0',
  `VERIFY_EMAIL` bit(1) NOT NULL DEFAULT b'0',
  `MASTER_ADMIN_CLIENT` varchar(36) DEFAULT NULL,
  `LOGIN_LIFESPAN` int DEFAULT NULL,
  `INTERNATIONALIZATION_ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `DEFAULT_LOCALE` varchar(255) DEFAULT NULL,
  `REG_EMAIL_AS_USERNAME` bit(1) NOT NULL DEFAULT b'0',
  `ADMIN_EVENTS_ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `ADMIN_EVENTS_DETAILS_ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `EDIT_USERNAME_ALLOWED` bit(1) NOT NULL DEFAULT b'0',
  `OTP_POLICY_COUNTER` int DEFAULT '0',
  `OTP_POLICY_WINDOW` int DEFAULT '1',
  `OTP_POLICY_PERIOD` int DEFAULT '30',
  `OTP_POLICY_DIGITS` int DEFAULT '6',
  `OTP_POLICY_ALG` varchar(36) DEFAULT 'HmacSHA1',
  `OTP_POLICY_TYPE` varchar(36) DEFAULT 'totp',
  `BROWSER_FLOW` varchar(36) DEFAULT NULL,
  `REGISTRATION_FLOW` varchar(36) DEFAULT NULL,
  `DIRECT_GRANT_FLOW` varchar(36) DEFAULT NULL,
  `RESET_CREDENTIALS_FLOW` varchar(36) DEFAULT NULL,
  `CLIENT_AUTH_FLOW` varchar(36) DEFAULT NULL,
  `OFFLINE_SESSION_IDLE_TIMEOUT` int DEFAULT '0',
  `REVOKE_REFRESH_TOKEN` bit(1) NOT NULL DEFAULT b'0',
  `ACCESS_TOKEN_LIFE_IMPLICIT` int DEFAULT '0',
  `LOGIN_WITH_EMAIL_ALLOWED` bit(1) NOT NULL DEFAULT b'1',
  `DUPLICATE_EMAILS_ALLOWED` bit(1) NOT NULL DEFAULT b'0',
  `DOCKER_AUTH_FLOW` varchar(36) DEFAULT NULL,
  `REFRESH_TOKEN_MAX_REUSE` int DEFAULT '0',
  `ALLOW_USER_MANAGED_ACCESS` bit(1) NOT NULL DEFAULT b'0',
  `SSO_MAX_LIFESPAN_REMEMBER_ME` int NOT NULL,
  `SSO_IDLE_TIMEOUT_REMEMBER_ME` int NOT NULL,
  `DEFAULT_ROLE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_ORVSDMLA56612EAEFIQ6WL5OI` (`NAME`),
  KEY `IDX_REALM_MASTER_ADM_CLI` (`MASTER_ADMIN_CLIENT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM`
--

LOCK TABLES `REALM` WRITE;
/*!40000 ALTER TABLE `REALM` DISABLE KEYS */;
INSERT INTO `REALM` VALUES ('master',60,300,60,NULL,NULL,NULL,_binary '',_binary '\0',0,NULL,'master',0,NULL,_binary '\0',_binary '\0',_binary '\0',_binary '\0','EXTERNAL',1800,36000,_binary '\0',_binary '\0','73dcb78f-3531-43f9-8a08-d1a50ba33a95',1800,_binary '\0',NULL,_binary '\0',_binary '\0',_binary '\0',_binary '\0',0,1,30,6,'HmacSHA1','totp','18d5447f-78ef-4e1b-9eda-a30a8add1db5','d9a855c9-ee0c-4a7b-a952-640c90516002','d9d8b731-7bd9-49b4-a6ee-fd8206198747','ee307d34-faf5-45db-926e-dba9fe96e260','efc1cf9c-85db-426d-a393-1ecda3c9acf1',2592000,_binary '\0',900,_binary '',_binary '\0','e7665ab0-dd72-4131-9f58-2e99c5e9a237',0,_binary '\0',0,0,'2e0919b2-6ca0-4186-a3f0-9aec5a9d2134'),('premier',60,300,300,NULL,NULL,NULL,_binary '',_binary '\0',0,NULL,'premier',0,NULL,_binary '',_binary '',_binary '',_binary '\0','EXTERNAL',1800,36000,_binary '\0',_binary '\0','0c682461-637b-4fc9-a380-fb1ea4151528',1800,_binary '\0',NULL,_binary '',_binary '\0',_binary '\0',_binary '\0',0,1,30,6,'HmacSHA1','totp','ee47c2c7-d606-4654-9b9a-739cdfb2f792','2ecd4887-fc55-4882-b43b-9c8ece1e856e','3014f6a9-f328-4c4a-97e1-3b1cf928360c','6c360044-47d7-43c2-a0c6-bd0e0956bd53','d15d2c19-16e2-4ac4-aceb-d896cf92afc5',2592000,_binary '\0',900,_binary '',_binary '\0','b9b41305-4658-4725-b1bf-d05363a7a3d4',0,_binary '\0',0,0,'e0d278f9-ea15-4ac5-8363-219d74ec1479');
/*!40000 ALTER TABLE `REALM` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_ATTRIBUTE`
--

DROP TABLE IF EXISTS `REALM_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_ATTRIBUTE` (
  `NAME` varchar(255) NOT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  `VALUE` longtext CHARACTER SET utf8mb3 COLLATE utf8_general_ci,
  PRIMARY KEY (`NAME`,`REALM_ID`),
  KEY `IDX_REALM_ATTR_REALM` (`REALM_ID`),
  CONSTRAINT `FK_8SHXD6L3E9ATQUKACXGPFFPTW` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_ATTRIBUTE`
--

LOCK TABLES `REALM_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `REALM_ATTRIBUTE` DISABLE KEYS */;
INSERT INTO `REALM_ATTRIBUTE` VALUES ('_browser_header.contentSecurityPolicy','master','frame-src \'self\'; frame-ancestors \'self\'; object-src \'none\';'),('_browser_header.contentSecurityPolicy','premier','frame-src \'self\'; frame-ancestors \'self\'; object-src \'none\';'),('_browser_header.contentSecurityPolicyReportOnly','master',''),('_browser_header.contentSecurityPolicyReportOnly','premier',''),('_browser_header.strictTransportSecurity','master','max-age=31536000; includeSubDomains'),('_browser_header.strictTransportSecurity','premier','max-age=31536000; includeSubDomains'),('_browser_header.xContentTypeOptions','master','nosniff'),('_browser_header.xContentTypeOptions','premier','nosniff'),('_browser_header.xFrameOptions','master','SAMEORIGIN'),('_browser_header.xFrameOptions','premier','SAMEORIGIN'),('_browser_header.xRobotsTag','master','none'),('_browser_header.xRobotsTag','premier','none'),('_browser_header.xXSSProtection','master','1; mode=block'),('_browser_header.xXSSProtection','premier','1; mode=block'),('actionTokenGeneratedByAdminLifespan','premier','43200'),('actionTokenGeneratedByUserLifespan','premier','300'),('bruteForceProtected','master','false'),('bruteForceProtected','premier','false'),('cibaAuthRequestedUserHint','premier','login_hint'),('cibaBackchannelTokenDeliveryMode','premier','poll'),('cibaExpiresIn','premier','120'),('cibaInterval','premier','5'),('client-policies.policies','premier','{\"policies\":[]}'),('client-policies.profiles','premier','{\"profiles\":[]}'),('clientOfflineSessionIdleTimeout','premier','0'),('clientOfflineSessionMaxLifespan','premier','0'),('clientSessionIdleTimeout','premier','0'),('clientSessionMaxLifespan','premier','0'),('defaultSignatureAlgorithm','master','RS256'),('defaultSignatureAlgorithm','premier','RS256'),('displayName','master','Keycloak'),('displayNameHtml','master','<div class=\"kc-logo-text\"><span>Keycloak</span></div>'),('failureFactor','master','30'),('failureFactor','premier','30'),('maxDeltaTimeSeconds','master','43200'),('maxDeltaTimeSeconds','premier','43200'),('maxFailureWaitSeconds','master','900'),('maxFailureWaitSeconds','premier','900'),('minimumQuickLoginWaitSeconds','master','60'),('minimumQuickLoginWaitSeconds','premier','60'),('oauth2DeviceCodeLifespan','premier','600'),('oauth2DevicePollingInterval','premier','5'),('offlineSessionMaxLifespan','master','5184000'),('offlineSessionMaxLifespan','premier','5184000'),('offlineSessionMaxLifespanEnabled','master','false'),('offlineSessionMaxLifespanEnabled','premier','false'),('parRequestUriLifespan','premier','60'),('permanentLockout','master','false'),('permanentLockout','premier','false'),('quickLoginCheckMilliSeconds','master','1000'),('quickLoginCheckMilliSeconds','premier','1000'),('waitIncrementSeconds','master','60'),('waitIncrementSeconds','premier','60'),('webAuthnPolicyAttestationConveyancePreference','premier','not specified'),('webAuthnPolicyAttestationConveyancePreferencePasswordless','premier','not specified'),('webAuthnPolicyAuthenticatorAttachment','premier','not specified'),('webAuthnPolicyAuthenticatorAttachmentPasswordless','premier','not specified'),('webAuthnPolicyAvoidSameAuthenticatorRegister','premier','false'),('webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless','premier','false'),('webAuthnPolicyCreateTimeout','premier','0'),('webAuthnPolicyCreateTimeoutPasswordless','premier','0'),('webAuthnPolicyRequireResidentKey','premier','not specified'),('webAuthnPolicyRequireResidentKeyPasswordless','premier','not specified'),('webAuthnPolicyRpEntityName','premier','keycloak'),('webAuthnPolicyRpEntityNamePasswordless','premier','keycloak'),('webAuthnPolicyRpId','premier',''),('webAuthnPolicyRpIdPasswordless','premier',''),('webAuthnPolicySignatureAlgorithms','premier','ES256'),('webAuthnPolicySignatureAlgorithmsPasswordless','premier','ES256'),('webAuthnPolicyUserVerificationRequirement','premier','not specified'),('webAuthnPolicyUserVerificationRequirementPasswordless','premier','not specified');
/*!40000 ALTER TABLE `REALM_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_DEFAULT_GROUPS`
--

DROP TABLE IF EXISTS `REALM_DEFAULT_GROUPS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_DEFAULT_GROUPS` (
  `REALM_ID` varchar(36) NOT NULL,
  `GROUP_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`REALM_ID`,`GROUP_ID`),
  UNIQUE KEY `CON_GROUP_ID_DEF_GROUPS` (`GROUP_ID`),
  KEY `IDX_REALM_DEF_GRP_REALM` (`REALM_ID`),
  CONSTRAINT `FK_DEF_GROUPS_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_DEFAULT_GROUPS`
--

LOCK TABLES `REALM_DEFAULT_GROUPS` WRITE;
/*!40000 ALTER TABLE `REALM_DEFAULT_GROUPS` DISABLE KEYS */;
/*!40000 ALTER TABLE `REALM_DEFAULT_GROUPS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_ENABLED_EVENT_TYPES`
--

DROP TABLE IF EXISTS `REALM_ENABLED_EVENT_TYPES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_ENABLED_EVENT_TYPES` (
  `REALM_ID` varchar(36) NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  PRIMARY KEY (`REALM_ID`,`VALUE`),
  KEY `IDX_REALM_EVT_TYPES_REALM` (`REALM_ID`),
  CONSTRAINT `FK_H846O4H0W8EPX5NWEDRF5Y69J` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_ENABLED_EVENT_TYPES`
--

LOCK TABLES `REALM_ENABLED_EVENT_TYPES` WRITE;
/*!40000 ALTER TABLE `REALM_ENABLED_EVENT_TYPES` DISABLE KEYS */;
/*!40000 ALTER TABLE `REALM_ENABLED_EVENT_TYPES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_EVENTS_LISTENERS`
--

DROP TABLE IF EXISTS `REALM_EVENTS_LISTENERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_EVENTS_LISTENERS` (
  `REALM_ID` varchar(36) NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  PRIMARY KEY (`REALM_ID`,`VALUE`),
  KEY `IDX_REALM_EVT_LIST_REALM` (`REALM_ID`),
  CONSTRAINT `FK_H846O4H0W8EPX5NXEV9F5Y69J` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_EVENTS_LISTENERS`
--

LOCK TABLES `REALM_EVENTS_LISTENERS` WRITE;
/*!40000 ALTER TABLE `REALM_EVENTS_LISTENERS` DISABLE KEYS */;
INSERT INTO `REALM_EVENTS_LISTENERS` VALUES ('master','jboss-logging'),('premier','jboss-logging');
/*!40000 ALTER TABLE `REALM_EVENTS_LISTENERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_LOCALIZATIONS`
--

DROP TABLE IF EXISTS `REALM_LOCALIZATIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_LOCALIZATIONS` (
  `REALM_ID` varchar(255) NOT NULL,
  `LOCALE` varchar(255) NOT NULL,
  `TEXTS` longtext CHARACTER SET utf8mb3 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`REALM_ID`,`LOCALE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_LOCALIZATIONS`
--

LOCK TABLES `REALM_LOCALIZATIONS` WRITE;
/*!40000 ALTER TABLE `REALM_LOCALIZATIONS` DISABLE KEYS */;
/*!40000 ALTER TABLE `REALM_LOCALIZATIONS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_REQUIRED_CREDENTIAL`
--

DROP TABLE IF EXISTS `REALM_REQUIRED_CREDENTIAL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_REQUIRED_CREDENTIAL` (
  `TYPE` varchar(255) NOT NULL,
  `FORM_LABEL` varchar(255) DEFAULT NULL,
  `INPUT` bit(1) NOT NULL DEFAULT b'0',
  `SECRET` bit(1) NOT NULL DEFAULT b'0',
  `REALM_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`REALM_ID`,`TYPE`),
  CONSTRAINT `FK_5HG65LYBEVAVKQFKI3KPONH9V` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_REQUIRED_CREDENTIAL`
--

LOCK TABLES `REALM_REQUIRED_CREDENTIAL` WRITE;
/*!40000 ALTER TABLE `REALM_REQUIRED_CREDENTIAL` DISABLE KEYS */;
INSERT INTO `REALM_REQUIRED_CREDENTIAL` VALUES ('password','password',_binary '',_binary '','master'),('password','password',_binary '',_binary '','premier');
/*!40000 ALTER TABLE `REALM_REQUIRED_CREDENTIAL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_SMTP_CONFIG`
--

DROP TABLE IF EXISTS `REALM_SMTP_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_SMTP_CONFIG` (
  `REALM_ID` varchar(36) NOT NULL,
  `VALUE` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`REALM_ID`,`NAME`),
  CONSTRAINT `FK_70EJ8XDXGXD0B9HH6180IRR0O` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_SMTP_CONFIG`
--

LOCK TABLES `REALM_SMTP_CONFIG` WRITE;
/*!40000 ALTER TABLE `REALM_SMTP_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `REALM_SMTP_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REALM_SUPPORTED_LOCALES`
--

DROP TABLE IF EXISTS `REALM_SUPPORTED_LOCALES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REALM_SUPPORTED_LOCALES` (
  `REALM_ID` varchar(36) NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  PRIMARY KEY (`REALM_ID`,`VALUE`),
  KEY `IDX_REALM_SUPP_LOCAL_REALM` (`REALM_ID`),
  CONSTRAINT `FK_SUPPORTED_LOCALES_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REALM_SUPPORTED_LOCALES`
--

LOCK TABLES `REALM_SUPPORTED_LOCALES` WRITE;
/*!40000 ALTER TABLE `REALM_SUPPORTED_LOCALES` DISABLE KEYS */;
/*!40000 ALTER TABLE `REALM_SUPPORTED_LOCALES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REDIRECT_URIS`
--

DROP TABLE IF EXISTS `REDIRECT_URIS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REDIRECT_URIS` (
  `CLIENT_ID` varchar(36) NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`VALUE`),
  KEY `IDX_REDIR_URI_CLIENT` (`CLIENT_ID`),
  CONSTRAINT `FK_1BURS8PB4OUJ97H5WUPPAHV9F` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REDIRECT_URIS`
--

LOCK TABLES `REDIRECT_URIS` WRITE;
/*!40000 ALTER TABLE `REDIRECT_URIS` DISABLE KEYS */;
INSERT INTO `REDIRECT_URIS` VALUES ('11ffd935-73b8-4ec7-a5ca-676c0b237009','/admin/master/console/*'),('2daf2562-be27-4374-a8e5-ec3724e075a4','http://localhost:8040/*'),('81532c06-1374-484f-98b7-099a30f05d3b','/realms/premier/account/*'),('cad92466-0a1a-4c35-b1fc-54343980c330','/realms/premier/account/*'),('cb82b8af-9a08-4467-930c-6fd317b867ba','/admin/premier/console/*'),('f2da4c42-aebd-4280-a1b4-96186777b481','/realms/master/account/*'),('fbcb07a8-8e18-4879-a845-6c164ea7452e','/realms/master/account/*');
/*!40000 ALTER TABLE `REDIRECT_URIS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REQUIRED_ACTION_CONFIG`
--

DROP TABLE IF EXISTS `REQUIRED_ACTION_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REQUIRED_ACTION_CONFIG` (
  `REQUIRED_ACTION_ID` varchar(36) NOT NULL,
  `VALUE` longtext,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`REQUIRED_ACTION_ID`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REQUIRED_ACTION_CONFIG`
--

LOCK TABLES `REQUIRED_ACTION_CONFIG` WRITE;
/*!40000 ALTER TABLE `REQUIRED_ACTION_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `REQUIRED_ACTION_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REQUIRED_ACTION_PROVIDER`
--

DROP TABLE IF EXISTS `REQUIRED_ACTION_PROVIDER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REQUIRED_ACTION_PROVIDER` (
  `ID` varchar(36) NOT NULL,
  `ALIAS` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(36) DEFAULT NULL,
  `ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `DEFAULT_ACTION` bit(1) NOT NULL DEFAULT b'0',
  `PROVIDER_ID` varchar(255) DEFAULT NULL,
  `PRIORITY` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_REQ_ACT_PROV_REALM` (`REALM_ID`),
  CONSTRAINT `FK_REQ_ACT_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REQUIRED_ACTION_PROVIDER`
--

LOCK TABLES `REQUIRED_ACTION_PROVIDER` WRITE;
/*!40000 ALTER TABLE `REQUIRED_ACTION_PROVIDER` DISABLE KEYS */;
INSERT INTO `REQUIRED_ACTION_PROVIDER` VALUES ('249b80e7-b755-47b6-b0b2-ec5d5f76f6a6','CONFIGURE_TOTP','Configure OTP','master',_binary '',_binary '\0','CONFIGURE_TOTP',10),('356eb18b-86b5-450e-906c-f6933c5764a3','UPDATE_PROFILE','Update Profile','premier',_binary '',_binary '\0','UPDATE_PROFILE',40),('3a51d3c8-c422-4556-a1ef-674200170faf','UPDATE_PASSWORD','Update Password','master',_binary '',_binary '\0','UPDATE_PASSWORD',30),('5b7c6cbc-95f0-4a28-af1a-bda84a6def6e','update_user_locale','Update User Locale','master',_binary '',_binary '\0','update_user_locale',1000),('64441ca6-3357-4b86-b08b-fc73c70acf4b','delete_account','Delete Account','master',_binary '\0',_binary '\0','delete_account',60),('804f245d-0579-4937-b9cf-570f51102e95','VERIFY_EMAIL','Verify Email','premier',_binary '',_binary '\0','VERIFY_EMAIL',50),('85f288ee-7c68-42f6-a796-c68cbbe204d1','delete_account','Delete Account','premier',_binary '\0',_binary '\0','delete_account',60),('9d7aeb54-4d9c-4697-891c-4b19b2a6f9b4','VERIFY_EMAIL','Verify Email','master',_binary '',_binary '\0','VERIFY_EMAIL',50),('a4c43da7-023c-491b-bc99-00d8f2618e32','UPDATE_PROFILE','Update Profile','master',_binary '',_binary '\0','UPDATE_PROFILE',40),('a6f32f4b-0c48-447f-8f16-4de83e45dc43','UPDATE_PASSWORD','Update Password','premier',_binary '',_binary '\0','UPDATE_PASSWORD',30),('a9003a03-a81a-49af-a0ba-8c6be5617595','update_user_locale','Update User Locale','premier',_binary '',_binary '\0','update_user_locale',1000),('b2057571-9416-4ccf-90fc-8c0563eab6f2','CONFIGURE_TOTP','Configure OTP','premier',_binary '',_binary '\0','CONFIGURE_TOTP',10),('b5cf37cd-2b12-423e-9825-0b0f0ab586c2','terms_and_conditions','Terms and Conditions','master',_binary '\0',_binary '\0','terms_and_conditions',20),('c4b73527-ed2b-4b44-a076-e0bf198dd4a3','terms_and_conditions','Terms and Conditions','premier',_binary '\0',_binary '\0','terms_and_conditions',20);
/*!40000 ALTER TABLE `REQUIRED_ACTION_PROVIDER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_ATTRIBUTE`
--

DROP TABLE IF EXISTS `RESOURCE_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_ATTRIBUTE` (
  `ID` varchar(36) NOT NULL DEFAULT 'sybase-needs-something-here',
  `NAME` varchar(255) NOT NULL,
  `VALUE` varchar(255) DEFAULT NULL,
  `RESOURCE_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_5HRM2VLF9QL5FU022KQEPOVBR` (`RESOURCE_ID`),
  CONSTRAINT `FK_5HRM2VLF9QL5FU022KQEPOVBR` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `RESOURCE_SERVER_RESOURCE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_ATTRIBUTE`
--

LOCK TABLES `RESOURCE_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `RESOURCE_ATTRIBUTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_POLICY`
--

DROP TABLE IF EXISTS `RESOURCE_POLICY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_POLICY` (
  `RESOURCE_ID` varchar(36) NOT NULL,
  `POLICY_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`RESOURCE_ID`,`POLICY_ID`),
  KEY `IDX_RES_POLICY_POLICY` (`POLICY_ID`),
  CONSTRAINT `FK_FRSRPOS53XCX4WNKOG82SSRFY` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `RESOURCE_SERVER_RESOURCE` (`ID`),
  CONSTRAINT `FK_FRSRPP213XCX4WNKOG82SSRFY` FOREIGN KEY (`POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_POLICY`
--

LOCK TABLES `RESOURCE_POLICY` WRITE;
/*!40000 ALTER TABLE `RESOURCE_POLICY` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_POLICY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SCOPE`
--

DROP TABLE IF EXISTS `RESOURCE_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SCOPE` (
  `RESOURCE_ID` varchar(36) NOT NULL,
  `SCOPE_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`RESOURCE_ID`,`SCOPE_ID`),
  KEY `IDX_RES_SCOPE_SCOPE` (`SCOPE_ID`),
  CONSTRAINT `FK_FRSRPOS13XCX4WNKOG82SSRFY` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `RESOURCE_SERVER_RESOURCE` (`ID`),
  CONSTRAINT `FK_FRSRPS213XCX4WNKOG82SSRFY` FOREIGN KEY (`SCOPE_ID`) REFERENCES `RESOURCE_SERVER_SCOPE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SCOPE`
--

LOCK TABLES `RESOURCE_SCOPE` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SCOPE` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SERVER`
--

DROP TABLE IF EXISTS `RESOURCE_SERVER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SERVER` (
  `ID` varchar(36) NOT NULL,
  `ALLOW_RS_REMOTE_MGMT` bit(1) NOT NULL DEFAULT b'0',
  `POLICY_ENFORCE_MODE` varchar(15) NOT NULL,
  `DECISION_STRATEGY` tinyint NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SERVER`
--

LOCK TABLES `RESOURCE_SERVER` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SERVER` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SERVER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SERVER_PERM_TICKET`
--

DROP TABLE IF EXISTS `RESOURCE_SERVER_PERM_TICKET`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SERVER_PERM_TICKET` (
  `ID` varchar(36) NOT NULL,
  `OWNER` varchar(255) DEFAULT NULL,
  `REQUESTER` varchar(255) DEFAULT NULL,
  `CREATED_TIMESTAMP` bigint NOT NULL,
  `GRANTED_TIMESTAMP` bigint DEFAULT NULL,
  `RESOURCE_ID` varchar(36) NOT NULL,
  `SCOPE_ID` varchar(36) DEFAULT NULL,
  `RESOURCE_SERVER_ID` varchar(36) NOT NULL,
  `POLICY_ID` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_FRSR6T700S9V50BU18WS5PMT` (`OWNER`,`REQUESTER`,`RESOURCE_SERVER_ID`,`RESOURCE_ID`,`SCOPE_ID`),
  KEY `FK_FRSRHO213XCX4WNKOG82SSPMT` (`RESOURCE_SERVER_ID`),
  KEY `FK_FRSRHO213XCX4WNKOG83SSPMT` (`RESOURCE_ID`),
  KEY `FK_FRSRHO213XCX4WNKOG84SSPMT` (`SCOPE_ID`),
  KEY `FK_FRSRPO2128CX4WNKOG82SSRFY` (`POLICY_ID`),
  CONSTRAINT `FK_FRSRHO213XCX4WNKOG82SSPMT` FOREIGN KEY (`RESOURCE_SERVER_ID`) REFERENCES `RESOURCE_SERVER` (`ID`),
  CONSTRAINT `FK_FRSRHO213XCX4WNKOG83SSPMT` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `RESOURCE_SERVER_RESOURCE` (`ID`),
  CONSTRAINT `FK_FRSRHO213XCX4WNKOG84SSPMT` FOREIGN KEY (`SCOPE_ID`) REFERENCES `RESOURCE_SERVER_SCOPE` (`ID`),
  CONSTRAINT `FK_FRSRPO2128CX4WNKOG82SSRFY` FOREIGN KEY (`POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SERVER_PERM_TICKET`
--

LOCK TABLES `RESOURCE_SERVER_PERM_TICKET` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SERVER_PERM_TICKET` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SERVER_PERM_TICKET` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SERVER_POLICY`
--

DROP TABLE IF EXISTS `RESOURCE_SERVER_POLICY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SERVER_POLICY` (
  `ID` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `TYPE` varchar(255) NOT NULL,
  `DECISION_STRATEGY` varchar(20) DEFAULT NULL,
  `LOGIC` varchar(20) DEFAULT NULL,
  `RESOURCE_SERVER_ID` varchar(36) DEFAULT NULL,
  `OWNER` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_FRSRPT700S9V50BU18WS5HA6` (`NAME`,`RESOURCE_SERVER_ID`),
  KEY `IDX_RES_SERV_POL_RES_SERV` (`RESOURCE_SERVER_ID`),
  CONSTRAINT `FK_FRSRPO213XCX4WNKOG82SSRFY` FOREIGN KEY (`RESOURCE_SERVER_ID`) REFERENCES `RESOURCE_SERVER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SERVER_POLICY`
--

LOCK TABLES `RESOURCE_SERVER_POLICY` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SERVER_POLICY` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SERVER_POLICY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SERVER_RESOURCE`
--

DROP TABLE IF EXISTS `RESOURCE_SERVER_RESOURCE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SERVER_RESOURCE` (
  `ID` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `ICON_URI` varchar(255) DEFAULT NULL,
  `OWNER` varchar(255) DEFAULT NULL,
  `RESOURCE_SERVER_ID` varchar(36) DEFAULT NULL,
  `OWNER_MANAGED_ACCESS` bit(1) NOT NULL DEFAULT b'0',
  `DISPLAY_NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_FRSR6T700S9V50BU18WS5HA6` (`NAME`,`OWNER`,`RESOURCE_SERVER_ID`),
  KEY `IDX_RES_SRV_RES_RES_SRV` (`RESOURCE_SERVER_ID`),
  CONSTRAINT `FK_FRSRHO213XCX4WNKOG82SSRFY` FOREIGN KEY (`RESOURCE_SERVER_ID`) REFERENCES `RESOURCE_SERVER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SERVER_RESOURCE`
--

LOCK TABLES `RESOURCE_SERVER_RESOURCE` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SERVER_RESOURCE` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SERVER_RESOURCE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_SERVER_SCOPE`
--

DROP TABLE IF EXISTS `RESOURCE_SERVER_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_SERVER_SCOPE` (
  `ID` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `ICON_URI` varchar(255) DEFAULT NULL,
  `RESOURCE_SERVER_ID` varchar(36) DEFAULT NULL,
  `DISPLAY_NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_FRSRST700S9V50BU18WS5HA6` (`NAME`,`RESOURCE_SERVER_ID`),
  KEY `IDX_RES_SRV_SCOPE_RES_SRV` (`RESOURCE_SERVER_ID`),
  CONSTRAINT `FK_FRSRSO213XCX4WNKOG82SSRFY` FOREIGN KEY (`RESOURCE_SERVER_ID`) REFERENCES `RESOURCE_SERVER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_SERVER_SCOPE`
--

LOCK TABLES `RESOURCE_SERVER_SCOPE` WRITE;
/*!40000 ALTER TABLE `RESOURCE_SERVER_SCOPE` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_SERVER_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RESOURCE_URIS`
--

DROP TABLE IF EXISTS `RESOURCE_URIS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RESOURCE_URIS` (
  `RESOURCE_ID` varchar(36) NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  PRIMARY KEY (`RESOURCE_ID`,`VALUE`),
  CONSTRAINT `FK_RESOURCE_SERVER_URIS` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `RESOURCE_SERVER_RESOURCE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RESOURCE_URIS`
--

LOCK TABLES `RESOURCE_URIS` WRITE;
/*!40000 ALTER TABLE `RESOURCE_URIS` DISABLE KEYS */;
/*!40000 ALTER TABLE `RESOURCE_URIS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ROLE_ATTRIBUTE`
--

DROP TABLE IF EXISTS `ROLE_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ROLE_ATTRIBUTE` (
  `ID` varchar(36) NOT NULL,
  `ROLE_ID` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_ROLE_ATTRIBUTE` (`ROLE_ID`),
  CONSTRAINT `FK_ROLE_ATTRIBUTE_ID` FOREIGN KEY (`ROLE_ID`) REFERENCES `KEYCLOAK_ROLE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ROLE_ATTRIBUTE`
--

LOCK TABLES `ROLE_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `ROLE_ATTRIBUTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `ROLE_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SCOPE_MAPPING`
--

DROP TABLE IF EXISTS `SCOPE_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SCOPE_MAPPING` (
  `CLIENT_ID` varchar(36) NOT NULL,
  `ROLE_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`ROLE_ID`),
  KEY `IDX_SCOPE_MAPPING_ROLE` (`ROLE_ID`),
  CONSTRAINT `FK_OUSE064PLMLR732LXJCN1Q5F1` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SCOPE_MAPPING`
--

LOCK TABLES `SCOPE_MAPPING` WRITE;
/*!40000 ALTER TABLE `SCOPE_MAPPING` DISABLE KEYS */;
INSERT INTO `SCOPE_MAPPING` VALUES ('fbcb07a8-8e18-4879-a845-6c164ea7452e','28f520e8-7a1b-4bb2-a29d-0bacdf508da0'),('cad92466-0a1a-4c35-b1fc-54343980c330','9cbed7db-4882-4874-8a88-cfbe4573212a');
/*!40000 ALTER TABLE `SCOPE_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SCOPE_POLICY`
--

DROP TABLE IF EXISTS `SCOPE_POLICY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SCOPE_POLICY` (
  `SCOPE_ID` varchar(36) NOT NULL,
  `POLICY_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`SCOPE_ID`,`POLICY_ID`),
  KEY `IDX_SCOPE_POLICY_POLICY` (`POLICY_ID`),
  CONSTRAINT `FK_FRSRASP13XCX4WNKOG82SSRFY` FOREIGN KEY (`POLICY_ID`) REFERENCES `RESOURCE_SERVER_POLICY` (`ID`),
  CONSTRAINT `FK_FRSRPASS3XCX4WNKOG82SSRFY` FOREIGN KEY (`SCOPE_ID`) REFERENCES `RESOURCE_SERVER_SCOPE` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SCOPE_POLICY`
--

LOCK TABLES `SCOPE_POLICY` WRITE;
/*!40000 ALTER TABLE `SCOPE_POLICY` DISABLE KEYS */;
/*!40000 ALTER TABLE `SCOPE_POLICY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USERNAME_LOGIN_FAILURE`
--

DROP TABLE IF EXISTS `USERNAME_LOGIN_FAILURE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USERNAME_LOGIN_FAILURE` (
  `REALM_ID` varchar(36) NOT NULL,
  `USERNAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci NOT NULL,
  `FAILED_LOGIN_NOT_BEFORE` int DEFAULT NULL,
  `LAST_FAILURE` bigint DEFAULT NULL,
  `LAST_IP_FAILURE` varchar(255) DEFAULT NULL,
  `NUM_FAILURES` int DEFAULT NULL,
  PRIMARY KEY (`REALM_ID`,`USERNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USERNAME_LOGIN_FAILURE`
--

LOCK TABLES `USERNAME_LOGIN_FAILURE` WRITE;
/*!40000 ALTER TABLE `USERNAME_LOGIN_FAILURE` DISABLE KEYS */;
/*!40000 ALTER TABLE `USERNAME_LOGIN_FAILURE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_ATTRIBUTE`
--

DROP TABLE IF EXISTS `USER_ATTRIBUTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_ATTRIBUTE` (
  `NAME` varchar(255) NOT NULL,
  `VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `USER_ID` varchar(36) NOT NULL,
  `ID` varchar(36) NOT NULL DEFAULT 'sybase-needs-something-here',
  PRIMARY KEY (`ID`),
  KEY `IDX_USER_ATTRIBUTE` (`USER_ID`),
  KEY `IDX_USER_ATTRIBUTE_NAME` (`NAME`,`VALUE`),
  CONSTRAINT `FK_5HRM2VLF9QL5FU043KQEPOVBR` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_ATTRIBUTE`
--

LOCK TABLES `USER_ATTRIBUTE` WRITE;
/*!40000 ALTER TABLE `USER_ATTRIBUTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_ATTRIBUTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_CONSENT`
--

DROP TABLE IF EXISTS `USER_CONSENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_CONSENT` (
  `ID` varchar(36) NOT NULL,
  `CLIENT_ID` varchar(255) DEFAULT NULL,
  `USER_ID` varchar(36) NOT NULL,
  `CREATED_DATE` bigint DEFAULT NULL,
  `LAST_UPDATED_DATE` bigint DEFAULT NULL,
  `CLIENT_STORAGE_PROVIDER` varchar(36) DEFAULT NULL,
  `EXTERNAL_CLIENT_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_JKUWUVD56ONTGSUHOGM8UEWRT` (`CLIENT_ID`,`CLIENT_STORAGE_PROVIDER`,`EXTERNAL_CLIENT_ID`,`USER_ID`),
  KEY `IDX_USER_CONSENT` (`USER_ID`),
  CONSTRAINT `FK_GRNTCSNT_USER` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_CONSENT`
--

LOCK TABLES `USER_CONSENT` WRITE;
/*!40000 ALTER TABLE `USER_CONSENT` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_CONSENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_CONSENT_CLIENT_SCOPE`
--

DROP TABLE IF EXISTS `USER_CONSENT_CLIENT_SCOPE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_CONSENT_CLIENT_SCOPE` (
  `USER_CONSENT_ID` varchar(36) NOT NULL,
  `SCOPE_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`USER_CONSENT_ID`,`SCOPE_ID`),
  KEY `IDX_USCONSENT_CLSCOPE` (`USER_CONSENT_ID`),
  CONSTRAINT `FK_GRNTCSNT_CLSC_USC` FOREIGN KEY (`USER_CONSENT_ID`) REFERENCES `USER_CONSENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_CONSENT_CLIENT_SCOPE`
--

LOCK TABLES `USER_CONSENT_CLIENT_SCOPE` WRITE;
/*!40000 ALTER TABLE `USER_CONSENT_CLIENT_SCOPE` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_CONSENT_CLIENT_SCOPE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_ENTITY`
--

DROP TABLE IF EXISTS `USER_ENTITY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_ENTITY` (
  `ID` varchar(36) NOT NULL,
  `EMAIL` varchar(255) DEFAULT NULL,
  `EMAIL_CONSTRAINT` varchar(255) DEFAULT NULL,
  `EMAIL_VERIFIED` bit(1) NOT NULL DEFAULT b'0',
  `ENABLED` bit(1) NOT NULL DEFAULT b'0',
  `FEDERATION_LINK` varchar(255) DEFAULT NULL,
  `FIRST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `LAST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `REALM_ID` varchar(255) DEFAULT NULL,
  `USERNAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL,
  `CREATED_TIMESTAMP` bigint DEFAULT NULL,
  `SERVICE_ACCOUNT_CLIENT_LINK` varchar(255) DEFAULT NULL,
  `NOT_BEFORE` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_DYKN684SL8UP1CRFEI6ECKHD7` (`REALM_ID`,`EMAIL_CONSTRAINT`),
  UNIQUE KEY `UK_RU8TT6T700S9V50BU18WS5HA6` (`REALM_ID`,`USERNAME`),
  KEY `IDX_USER_EMAIL` (`EMAIL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_ENTITY`
--

LOCK TABLES `USER_ENTITY` WRITE;
/*!40000 ALTER TABLE `USER_ENTITY` DISABLE KEYS */;
INSERT INTO `USER_ENTITY` VALUES ('6dad8cd6-f02c-4c00-b54f-1d4f5a6046c9','premier@example.com','premier@example.com',_binary '\0',_binary '',NULL,'Premier','Example','premier','premier@example.com',1652620212509,NULL,0),('a9c03fe3-e211-43ac-a388-8f23780a0172',NULL,'f5bbc373-c348-41bc-981a-c6c144999e13',_binary '\0',_binary '',NULL,NULL,NULL,'master','keycloak',1652620084826,NULL,0);
/*!40000 ALTER TABLE `USER_ENTITY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_FEDERATION_CONFIG`
--

DROP TABLE IF EXISTS `USER_FEDERATION_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_FEDERATION_CONFIG` (
  `USER_FEDERATION_PROVIDER_ID` varchar(36) NOT NULL,
  `VALUE` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`USER_FEDERATION_PROVIDER_ID`,`NAME`),
  CONSTRAINT `FK_T13HPU1J94R2EBPEKR39X5EU5` FOREIGN KEY (`USER_FEDERATION_PROVIDER_ID`) REFERENCES `USER_FEDERATION_PROVIDER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_FEDERATION_CONFIG`
--

LOCK TABLES `USER_FEDERATION_CONFIG` WRITE;
/*!40000 ALTER TABLE `USER_FEDERATION_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_FEDERATION_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_FEDERATION_MAPPER`
--

DROP TABLE IF EXISTS `USER_FEDERATION_MAPPER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_FEDERATION_MAPPER` (
  `ID` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `FEDERATION_PROVIDER_ID` varchar(36) NOT NULL,
  `FEDERATION_MAPPER_TYPE` varchar(255) NOT NULL,
  `REALM_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_USR_FED_MAP_FED_PRV` (`FEDERATION_PROVIDER_ID`),
  KEY `IDX_USR_FED_MAP_REALM` (`REALM_ID`),
  CONSTRAINT `FK_FEDMAPPERPM_FEDPRV` FOREIGN KEY (`FEDERATION_PROVIDER_ID`) REFERENCES `USER_FEDERATION_PROVIDER` (`ID`),
  CONSTRAINT `FK_FEDMAPPERPM_REALM` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_FEDERATION_MAPPER`
--

LOCK TABLES `USER_FEDERATION_MAPPER` WRITE;
/*!40000 ALTER TABLE `USER_FEDERATION_MAPPER` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_FEDERATION_MAPPER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_FEDERATION_MAPPER_CONFIG`
--

DROP TABLE IF EXISTS `USER_FEDERATION_MAPPER_CONFIG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_FEDERATION_MAPPER_CONFIG` (
  `USER_FEDERATION_MAPPER_ID` varchar(36) NOT NULL,
  `VALUE` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`USER_FEDERATION_MAPPER_ID`,`NAME`),
  CONSTRAINT `FK_FEDMAPPER_CFG` FOREIGN KEY (`USER_FEDERATION_MAPPER_ID`) REFERENCES `USER_FEDERATION_MAPPER` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_FEDERATION_MAPPER_CONFIG`
--

LOCK TABLES `USER_FEDERATION_MAPPER_CONFIG` WRITE;
/*!40000 ALTER TABLE `USER_FEDERATION_MAPPER_CONFIG` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_FEDERATION_MAPPER_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_FEDERATION_PROVIDER`
--

DROP TABLE IF EXISTS `USER_FEDERATION_PROVIDER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_FEDERATION_PROVIDER` (
  `ID` varchar(36) NOT NULL,
  `CHANGED_SYNC_PERIOD` int DEFAULT NULL,
  `DISPLAY_NAME` varchar(255) DEFAULT NULL,
  `FULL_SYNC_PERIOD` int DEFAULT NULL,
  `LAST_SYNC` int DEFAULT NULL,
  `PRIORITY` int DEFAULT NULL,
  `PROVIDER_NAME` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_USR_FED_PRV_REALM` (`REALM_ID`),
  CONSTRAINT `FK_1FJ32F6PTOLW2QY60CD8N01E8` FOREIGN KEY (`REALM_ID`) REFERENCES `REALM` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_FEDERATION_PROVIDER`
--

LOCK TABLES `USER_FEDERATION_PROVIDER` WRITE;
/*!40000 ALTER TABLE `USER_FEDERATION_PROVIDER` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_FEDERATION_PROVIDER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_GROUP_MEMBERSHIP`
--

DROP TABLE IF EXISTS `USER_GROUP_MEMBERSHIP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_GROUP_MEMBERSHIP` (
  `GROUP_ID` varchar(36) NOT NULL,
  `USER_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`GROUP_ID`,`USER_ID`),
  KEY `IDX_USER_GROUP_MAPPING` (`USER_ID`),
  CONSTRAINT `FK_USER_GROUP_USER` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_GROUP_MEMBERSHIP`
--

LOCK TABLES `USER_GROUP_MEMBERSHIP` WRITE;
/*!40000 ALTER TABLE `USER_GROUP_MEMBERSHIP` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_GROUP_MEMBERSHIP` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_REQUIRED_ACTION`
--

DROP TABLE IF EXISTS `USER_REQUIRED_ACTION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_REQUIRED_ACTION` (
  `USER_ID` varchar(36) NOT NULL,
  `REQUIRED_ACTION` varchar(255) NOT NULL DEFAULT ' ',
  PRIMARY KEY (`REQUIRED_ACTION`,`USER_ID`),
  KEY `IDX_USER_REQACTIONS` (`USER_ID`),
  CONSTRAINT `FK_6QJ3W1JW9CVAFHE19BWSIUVMD` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_REQUIRED_ACTION`
--

LOCK TABLES `USER_REQUIRED_ACTION` WRITE;
/*!40000 ALTER TABLE `USER_REQUIRED_ACTION` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_REQUIRED_ACTION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_ROLE_MAPPING`
--

DROP TABLE IF EXISTS `USER_ROLE_MAPPING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_ROLE_MAPPING` (
  `ROLE_ID` varchar(255) NOT NULL,
  `USER_ID` varchar(36) NOT NULL,
  PRIMARY KEY (`ROLE_ID`,`USER_ID`),
  KEY `IDX_USER_ROLE_MAPPING` (`USER_ID`),
  CONSTRAINT `FK_C4FQV34P1MBYLLOXANG7B1Q3L` FOREIGN KEY (`USER_ID`) REFERENCES `USER_ENTITY` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_ROLE_MAPPING`
--

LOCK TABLES `USER_ROLE_MAPPING` WRITE;
/*!40000 ALTER TABLE `USER_ROLE_MAPPING` DISABLE KEYS */;
INSERT INTO `USER_ROLE_MAPPING` VALUES ('e0d278f9-ea15-4ac5-8363-219d74ec1479','6dad8cd6-f02c-4c00-b54f-1d4f5a6046c9'),('2045428f-0df8-4dfa-9993-ac5862a39e38','a9c03fe3-e211-43ac-a388-8f23780a0172'),('2dfd389d-b2c6-4f11-99d7-ea06454f37aa','a9c03fe3-e211-43ac-a388-8f23780a0172'),('2e0919b2-6ca0-4186-a3f0-9aec5a9d2134','a9c03fe3-e211-43ac-a388-8f23780a0172'),('2e65cd6f-2c43-4943-a58d-c94680f9f9f9','a9c03fe3-e211-43ac-a388-8f23780a0172'),('41b10923-3f04-4499-b032-63f96d5b0d36','a9c03fe3-e211-43ac-a388-8f23780a0172'),('44c97cea-81db-4e52-8aea-9a5beb98f0f6','a9c03fe3-e211-43ac-a388-8f23780a0172'),('486a91b4-5072-4c54-9273-0e4414d997be','a9c03fe3-e211-43ac-a388-8f23780a0172'),('4c1d179b-9bdd-4709-9337-8a93f80ab8c3','a9c03fe3-e211-43ac-a388-8f23780a0172'),('4d141db3-35c0-44c4-8e11-e927bfc5b139','a9c03fe3-e211-43ac-a388-8f23780a0172'),('5cdd5173-0d68-4bc6-9e8d-9458fdeb84c2','a9c03fe3-e211-43ac-a388-8f23780a0172'),('64c9b809-7224-446d-ae4c-73a4940290b1','a9c03fe3-e211-43ac-a388-8f23780a0172'),('67faf19b-ae4f-4d7d-823f-556344919faa','a9c03fe3-e211-43ac-a388-8f23780a0172'),('687373c8-6ab5-4967-bafd-28dd26369be3','a9c03fe3-e211-43ac-a388-8f23780a0172'),('6c6ca9f0-6f57-4756-a720-9e7bea72a050','a9c03fe3-e211-43ac-a388-8f23780a0172'),('6fda947e-52fe-4235-81e9-0057137425fe','a9c03fe3-e211-43ac-a388-8f23780a0172'),('828e83ce-089f-462e-95c7-8456e5148243','a9c03fe3-e211-43ac-a388-8f23780a0172'),('8b9bf70c-2e9d-4402-bac2-55dbca468cc6','a9c03fe3-e211-43ac-a388-8f23780a0172'),('c0f03b74-0356-4c3b-a1bf-91503d91305b','a9c03fe3-e211-43ac-a388-8f23780a0172'),('c3f9d5ca-bb6f-47d4-acd6-9d76fb180797','a9c03fe3-e211-43ac-a388-8f23780a0172');
/*!40000 ALTER TABLE `USER_ROLE_MAPPING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_SESSION`
--

DROP TABLE IF EXISTS `USER_SESSION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_SESSION` (
  `ID` varchar(36) NOT NULL,
  `AUTH_METHOD` varchar(255) DEFAULT NULL,
  `IP_ADDRESS` varchar(255) DEFAULT NULL,
  `LAST_SESSION_REFRESH` int DEFAULT NULL,
  `LOGIN_USERNAME` varchar(255) DEFAULT NULL,
  `REALM_ID` varchar(255) DEFAULT NULL,
  `REMEMBER_ME` bit(1) NOT NULL DEFAULT b'0',
  `STARTED` int DEFAULT NULL,
  `USER_ID` varchar(255) DEFAULT NULL,
  `USER_SESSION_STATE` int DEFAULT NULL,
  `BROKER_SESSION_ID` varchar(255) DEFAULT NULL,
  `BROKER_USER_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_SESSION`
--

LOCK TABLES `USER_SESSION` WRITE;
/*!40000 ALTER TABLE `USER_SESSION` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_SESSION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER_SESSION_NOTE`
--

DROP TABLE IF EXISTS `USER_SESSION_NOTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER_SESSION_NOTE` (
  `USER_SESSION` varchar(36) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `VALUE` text,
  PRIMARY KEY (`USER_SESSION`,`NAME`),
  CONSTRAINT `FK5EDFB00FF51D3472` FOREIGN KEY (`USER_SESSION`) REFERENCES `USER_SESSION` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_SESSION_NOTE`
--

LOCK TABLES `USER_SESSION_NOTE` WRITE;
/*!40000 ALTER TABLE `USER_SESSION_NOTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_SESSION_NOTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WEB_ORIGINS`
--

DROP TABLE IF EXISTS `WEB_ORIGINS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WEB_ORIGINS` (
  `CLIENT_ID` varchar(36) NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  PRIMARY KEY (`CLIENT_ID`,`VALUE`),
  KEY `IDX_WEB_ORIG_CLIENT` (`CLIENT_ID`),
  CONSTRAINT `FK_LOJPHO213XCX4WNKOG82SSRFY` FOREIGN KEY (`CLIENT_ID`) REFERENCES `CLIENT` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WEB_ORIGINS`
--

LOCK TABLES `WEB_ORIGINS` WRITE;
/*!40000 ALTER TABLE `WEB_ORIGINS` DISABLE KEYS */;
INSERT INTO `WEB_ORIGINS` VALUES ('11ffd935-73b8-4ec7-a5ca-676c0b237009','+'),('2daf2562-be27-4374-a8e5-ec3724e075a4','http://localhost:8040'),('cb82b8af-9a08-4467-930c-6fd317b867ba','+');
/*!40000 ALTER TABLE `WEB_ORIGINS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-05-15 13:12:23
