-- --------------------------------------------------------
-- 主机:                           127.0.0.1
-- Server version:               10.3.14-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL 版本:                  10.1.0.5464
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for hit
CREATE DATABASE IF NOT EXISTS `hit` /*!40100 DEFAULT CHARACTER SET gbk */;
USE `hit`;

-- Dumping structure for table hit.h_modality
CREATE TABLE IF NOT EXISTS `h_modality` (
  `ModalityIdentity` int(11) NOT NULL,
  `ModalityAET` char(50) DEFAULT NULL,
  `ModalityManufacturer` char(50) DEFAULT NULL,
  `ModalityIPAddr` char(50) DEFAULT NULL,
  `ModalityType` char(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='设备基本信息维护表';

-- Dumping data for table hit.h_modality: ~1 rows (approximately)
/*!40000 ALTER TABLE `h_modality` DISABLE KEYS */;
INSERT INTO `h_modality` (`ModalityIdentity`, `ModalityAET`, `ModalityManufacturer`, `ModalityIPAddr`, `ModalityType`) VALUES
	(123456, 'GECT1', 'GE', '192.168.22.155', NULL);
/*!40000 ALTER TABLE `h_modality` ENABLE KEYS */;

-- Dumping structure for table hit.h_order
CREATE TABLE IF NOT EXISTS `h_order` (
  `StudyOrderIdentity` bigint(64) NOT NULL COMMENT '预约检查主索引',
  `PatientIdentity` bigint(64) NOT NULL COMMENT '患者唯一ID',
  `StudyID` char(50) DEFAULT NULL COMMENT '检查号ID',
  `StudyUID` char(50) DEFAULT NULL COMMENT '检查UID',
  `StudyModality` char(50) DEFAULT NULL COMMENT '检查设备',
  `ScheduledDateTime` datetime DEFAULT NULL COMMENT '预约设备检查时间',
  `AETitle` char(50) DEFAULT NULL COMMENT '设备AE',
  `OrderDateTime` datetime DEFAULT current_timestamp() COMMENT '登记预约的时间',
  `StudyDescription` longtext DEFAULT NULL,
  `StudyDepart` char(50) DEFAULT NULL COMMENT '检查的科室',
  `StudyCode` char(128) DEFAULT '0000' COMMENT '用于对应设备的检查部位编码使用',
  `StudyCost` varchar(50) DEFAULT '0',
  `CostType` char(50) DEFAULT NULL COMMENT '检查的费用方式',
  `StudyType` int(11) DEFAULT 0 COMMENT '0影像设备检查',
  `StudyState` int(11) DEFAULT 1 COMMENT '检查状态：-1.标记删除 1.预约 2.等待检查 3.已检查 4.诊断 5.报告审核',
  PRIMARY KEY (`StudyOrderIdentity`),
  KEY `PatientIdentity` (`PatientIdentity`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk COMMENT='设备检查预约表';

-- Dumping data for table hit.h_order: ~14 rows (approximately)
/*!40000 ALTER TABLE `h_order` DISABLE KEYS */;
INSERT INTO `h_order` (`StudyOrderIdentity`, `PatientIdentity`, `StudyID`, `StudyUID`, `StudyModality`, `ScheduledDateTime`, `AETitle`, `OrderDateTime`, `StudyDescription`, `StudyDepart`, `StudyCode`, `StudyCost`, `CostType`, `StudyType`, `StudyState`) VALUES
	(1577159650141, 1577159649832, '20191224115410', '1.2.826.0.1.3680043.9.7604.20191224115410.157715', 'US', '2019-12-30 00:00:00', NULL, '2019-12-24 11:54:10', 'qqqqqwwww333211122222222222222qwqeqwreqrewqqqqqqqqqqqqqq', '20', NULL, '1147.89', '公费', 0, 1),
	(1577160124447, 1577160124339, '20191224120204', '1.2.826.0.1.3680043.9.7604.20191224120204.157716', 'MR', '2019-12-24 00:00:00', NULL, '2019-12-24 12:02:04', '广东省深圳市南山区留仙大道光明大厦12#3单元3004', '11', NULL, '9009', '半公费', 0, 1),
	(1577191056762, 1577191056716, '20191224203736', '1.2.826.0.1.3680043.9.7604.20191224203736.157719', 'CT', '2019-12-26 00:00:00', NULL, '2019-12-24 20:37:36', '广东省广州市天河区符号别墅11#2单元201 超声检查', '11', NULL, '4000', '其它', 0, 1),
	(1577192229811, 1577191056716, '20191224205709', '1.2.826.0.1.3680043.9.7604.20191224205709.157719', 'US', '2019-12-26 00:00:00', NULL, '2019-12-24 20:57:09', '广东省广州市天河区符号别墅11#2单元201 超声检查', '21', NULL, '10009', '公费', 0, 1),
	(1577260266796, 3154520532296, '20191225155106', '1.2.826.0.1.3680043.9.7604.20191225155106.157726', 'DR', '2019-12-26 00:00:00', NULL, '2019-12-25 15:51:06', '广东省广州市天河区', '10', NULL, '1008', '公费', 0, 1),
	(1577698117739, 1577698117606, '20191230172837', '1.2.826.0.1.3680043.9.7604.20191230172837.157769', 'DR', '2020-01-03 00:00:00', NULL, '2019-12-30 17:28:37', 'wwwwwwwwwwwwwww', '11', NULL, '120', '自费', 0, 1),
	(1577698278016, 1577698277364, '20191230173118', '1.2.826.0.1.3680043.9.7604.20191230173118.157769', 'US', '2019-12-30 00:00:00', NULL, '2019-12-30 17:31:18', 'qqqqqqqqqqqqqq', '20', NULL, '12132', '半公费', 0, 1),
	(1577698351769, 1577698351658, '20191230173231', '1.2.826.0.1.3680043.9.7604.20191230173231.157769', 'MR', '2019-12-30 00:00:00', NULL, '2019-12-30 17:32:31', 'test@126.comtest@126.comtest@126.comtest@126.comtest@126.com', '11', NULL, '3231', '半公费', 0, 1),
	(1577698397739, 1577698397630, '20191230173317', '1.2.826.0.1.3680043.9.7604.20191230173317.157769', 'ES', '2019-12-30 00:00:00', NULL, '2019-12-30 17:33:17', 'test@126.comtest@126.comtest@126.comtest@126.com', '31', NULL, '111111', '其它', 0, 1),
	(1578390820084, 1578390819954, '20200107175340', '1.2.826.0.1.3680043.9.7604.20200107175340.157839', 'MR', '2020-01-08 00:00:00', NULL, '2020-01-07 17:53:40', '分页测试分页测试分页测试分页测试分页测试分页测试分页测试分页测试分页测试分页测试', '10', NULL, '100', '自费', 0, 1),
	(1578469675979, 1577159649832, '20200108154755', '1.2.826.0.1.3680043.9.7604.20200108154755.157846', 'US', '2020-01-16 00:00:00', NULL, '2020-01-08 15:47:55', '测试同一个患者多个预约检查测试同一个患者多个预约检查测试同一个患者多个预约检查测试同一个患者多个预约检查测试同一个患者多个预约检查', '21', NULL, '200', '公费', 0, 1),
	(1578471402248, 1578471401942, '20200108161642', '1.2.826.0.1.3680043.9.7604.20200108161642.157847', 'CT', '2020-01-08 00:00:00', NULL, '2020-01-08 16:16:42', '维尔沃尔特如果让他合同以及体育', '11', NULL, '123', '自费', 0, 1),
	(1578485916056, 1578485916016, '20200108201836', '1.2.826.0.1.3680043.9.7604.20200108201836.157848', 'DR', '2020-01-16 00:00:00', NULL, '2020-01-08 20:18:36', 'Test_TestTest_TestTest_TestTest_TestTest_TestTest_Test', '10', NULL, '100', '公费', 0, 1),
	(1578658203752, 1577160124339, '20200110201003', '1.2.826.0.1.3680043.9.7604.20200110201003.157865', 'MR', '2020-01-31 00:00:00', NULL, '2020-01-10 20:10:03', '测试报告保存测试报告测试报告保存测试报告测试报告保存测试报告测试报告保存测试报告测试报告保存测试报告测试报告保存测试报告测试报告保存测试报告', '10', NULL, '1212', '公费', 0, 1),
	(1578922486001, 1577159649832, '20200113213446', '1.2.826.0.1.3680043.9.7604.20200113213446.157892', 'CT', '2020-01-13 00:00:00', NULL, '2020-01-13 21:34:46', '广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?广东省深圳市南山区留仙大道光明大厦12#3单元3004_?', '10', NULL, '1231', '公费', 0, 1),
	(3092356220974197000, 1577159649832, '20191224214228', '1.2.826.0.1.3680043.9.7604.20191224214228.157719', 'MR', '2020-01-01 00:00:00', NULL, '2019-12-24 21:42:28', '测试水水水水水水水是生生世世ccccc测试 测色噩噩噩噩噩噩噩噩巍峨巍峨巍峨瓦尔特太太平台热特热【入菩提而【葡萄干科idkvdkvergperkergte【热特热【提供客人【顾客如果【客人股票【库萨婆；更可怕更可怕入口即评价干部恶评', '11', NULL, '100.9', '半公费', 0, 1);
/*!40000 ALTER TABLE `h_order` ENABLE KEYS */;

-- Dumping structure for table hit.h_patient
CREATE TABLE IF NOT EXISTS `h_patient` (
  `PatientIdentity` bigint(64) unsigned NOT NULL,
  `PatientID` char(50) NOT NULL,
  `PatientName` char(50) DEFAULT NULL,
  `PatientNameEnglish` char(50) DEFAULT NULL,
  `PatientSex` char(10) DEFAULT 'O',
  `PatientBirthday` char(22) DEFAULT NULL,
  `PatientAddr` varchar(50) DEFAULT NULL,
  `PatientEmail` varchar(50) DEFAULT NULL,
  `PatientCarID` varchar(50) DEFAULT NULL,
  `PatientTelNumber` varchar(50) DEFAULT NULL,
  `PatientType` int(11) DEFAULT 0,
  `PatientState` int(11) DEFAULT 0 COMMENT '定义患者状态 小于0 wei标记删除',
  PRIMARY KEY (`PatientIdentity`),
  KEY `PatientID` (`PatientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='患者基本信息';

-- Dumping data for table hit.h_patient: ~25 rows (approximately)
/*!40000 ALTER TABLE `h_patient` DISABLE KEYS */;
INSERT INTO `h_patient` (`PatientIdentity`, `PatientID`, `PatientName`, `PatientNameEnglish`, `PatientSex`, `PatientBirthday`, `PatientAddr`, `PatientEmail`, `PatientCarID`, `PatientTelNumber`, `PatientType`, `PatientState`) VALUES
	(1577159649832, '1577159649832', 'test1_modify', NULL, 'M', '19670808', '广东省深圳市南山区留仙大道光明大厦12#3单元3004_?', 'test@126.com', '121324234234', '12345678', 0, 0),
	(1577160124339, '1577160124339', 'test_02', NULL, 'M', '20191224', '广东省深圳市南山区留仙大道光明大厦12#3单元3004', 'test@126.com', '123123', '1213231', 0, 0),
	(1577191056716, '1577191056716', 'TestNew', NULL, 'M', '19081224', '广东省广州市天河区符号别墅11#2单元201', 'test@126.com', '12313123123414', '1231124', 0, 0),
	(1577698117606, '1577698117606', 'q121请问恶趣味额', NULL, 'M', '19801230', '3232323', '12@126.com', '323', '1', 0, 0),
	(1577698277364, '1577698277364', 's', NULL, 'M', '20121030', '322423', 'q@163.com', '1212332342332', '3231', 0, 0),
	(1577698351658, '1577698351658', 'test@126.com', NULL, 'M', '20071230', 'test@126.com', 'test@126.com', '42323232323', '3333333', 0, 0),
	(1577698397630, '1577698397630', 'qwtest@126.com', NULL, 'M', '19981230', 'test@126.comtest@126.comtest@126.comtest@126.com', 'stest@126.com', '76576767', '5555555555', 0, 0),
	(1578390819954, '1578390819954', '分页测试', NULL, 'M', '19900507', '分页测试分页测试分页测试分页测试分页测试', 'erewqrwerw@126.com', '31342342342', '212312312341241241', 0, 0),
	(1578471401942, '1578471401942', '去问额外去', NULL, 'M', '19990108', 'gerretyrt人格人格要人提金眼科记录i', '1@q.com', '32134', '1231', 0, 0),
	(1578485916016, '1578485916016', 'Test_Test', NULL, 'M', '19840108', 'Test_TestTest_TestTest_TestTest_TestTest_Test', '1@163.com', '3123234', '12312424', 0, 0),
	(3154520532296, '1577260266148', 'TTTTTT', NULL, 'M', '20101225', '广东省广州市天河区', 'aaaaaaa@126.com', '22222222222222', '222222222222', 0, 0),
	(9549157174405505146, '1346269', 'MSMG', '', '', '', NULL, NULL, NULL, NULL, 0, 0),
	(9549158132696960539, '46595', 'TestQR_Name', '', 'F', '19530301', NULL, NULL, NULL, NULL, 0, 0),
	(9549164353508537023, '9227465', 'MISTERCR', '', '', '', NULL, NULL, NULL, NULL, 0, 0),
	(9549164602208472656, 'ozp00SjY2xG[SERIES]', '', '', '', '', NULL, NULL, NULL, NULL, 0, 0),
	(9549170614779528579, '20190206', '****', '', 'M', '19401121', NULL, NULL, NULL, NULL, 0, 0),
	(9549232603989169135, '20199155', 'TestName', '', 'M', '19641203', NULL, NULL, NULL, NULL, 0, 0),
	(9549235563987090580, '1364755', 'Sun AiMei', '', 'F', '19540722', NULL, NULL, NULL, NULL, 0, 0),
	(9549657812752528889, '20441382', 'ZhangJianWei', '', 'M', '19591211', NULL, NULL, NULL, NULL, 0, 0),
	(9549663143347768242, '20191934', 'Deng ZiRong', '', 'M', '19450901', NULL, NULL, NULL, NULL, 0, 0),
	(9549728573829102880, '20199011', 'Li GuiDi', '', 'F', '19621021', NULL, NULL, NULL, NULL, 0, 0),
	(9549772602444259965, '20199267', 'Xu XiuCong', '', 'M', '19680802', NULL, NULL, NULL, NULL, 0, 0),
	(9549778360612934657, '832040', 'MISTERMR', '', '', '', NULL, NULL, NULL, NULL, 0, 0),
	(9549785367158836510, '20087090', '****', '', 'M', '19301229', NULL, NULL, NULL, NULL, 0, 0),
	(9549838092637045117, '2178309', 'MISTERCT', '', '', '', NULL, NULL, NULL, NULL, 0, 0),
	(9549840073405918032, '12345678', 'PatientAnonymous', '', 'M', '19560324', NULL, NULL, NULL, NULL, 0, 0),
	(9549844662405948441, '3524578', 'MISTERDX', '', '', '', NULL, NULL, NULL, NULL, 0, 0),
	(9549847056042619428, '20187599', '****', '', 'M', '19540510', NULL, NULL, NULL, NULL, 0, 0);
/*!40000 ALTER TABLE `h_patient` ENABLE KEYS */;

-- Dumping structure for table hit.h_report
CREATE TABLE IF NOT EXISTS `h_report` (
  `ReportIdentity` bigint(20) NOT NULL,
  `StudyOrderIdentity` bigint(20) NOT NULL,
  `ReportState` int(11) DEFAULT NULL COMMENT '报告状态????? 0.空文档 1.草稿 2.加载 3.审核',
  `ReportTemplate` longtext DEFAULT NULL COMMENT '报告模板名称',
  `ReportCreatDate` datetime DEFAULT current_timestamp() COMMENT '报告创建时间',
  `ReportWriterID` char(50) DEFAULT NULL COMMENT '报告医生ID',
  `ReportCheckID` char(50) DEFAULT NULL COMMENT '审核医生ID',
  `ReportCheckDate` datetime DEFAULT current_timestamp() COMMENT '审核时间',
  `ReportContent` longtext DEFAULT NULL COMMENT '报告内容',
  `ReportOther` longtext DEFAULT NULL COMMENT '报告扩展字符',
  PRIMARY KEY (`ReportIdentity`),
  KEY `StudyOrderIdentity` (`StudyOrderIdentity`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk COMMENT='患者检查报告内容二进制';

-- Dumping data for table hit.h_report: ~14 rows (approximately)
/*!40000 ALTER TABLE `h_report` DISABLE KEYS */;
INSERT INTO `h_report` (`ReportIdentity`, `StudyOrderIdentity`, `ReportState`, `ReportTemplate`, `ReportCreatDate`, `ReportWriterID`, `ReportCheckID`, `ReportCheckDate`, `ReportContent`, `ReportOther`) VALUES
	(1577159650141, 1577159650141, 0, '', '2019-12-28 17:11:11', '', '', '2019-12-28 17:11:11', '<h1 style="text-align: center;"><span style="background-color: #e42020;"><strong>XXXX医院</strong></span></h1>\n<p>1577159650141&nbsp;</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是<strong>测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，</strong>这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1577160124447, 1577160124447, 0, '', '2019-12-28 17:13:52', '', '', '2019-12-28 17:13:52', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p>1577160124447</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="background-color: #e03e2d;">&nbsp;这是测</span>试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1577191056762, 1577191056762, 0, '', '2019-12-28 17:20:09', '', '', '2019-12-28 17:20:09', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p>1577191056762</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1577192229811, 1577192229811, 0, '', '2019-12-28 17:25:15', '', '', '2019-12-28 17:25:15', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<span style="background-color: #e42020;"> &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</span></p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1577260266796, 1577260266796, 0, '', '2019-12-27 16:15:39', '', '', '2019-12-27 16:15:39', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p>1577260266796</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</p>', ''),
	(1577698117739, 1577698117739, 0, '', '2019-12-30 22:36:26', '', '', '2019-12-30 22:36:26', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p>#########################################################</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="background-color: #e03e2d;">&nbsp;这是测</span>试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1577698278016, 1577698278016, 0, '', '2019-12-30 22:34:48', '', '', '2019-12-30 22:34:48', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p>-------------------</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="background-color: #e03e2d;">&nbsp;这是测</span>试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，<span style="background-color: #2dc26b;">这</span>是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1577698351769, 1577698351769, 0, '', '2020-01-03 10:44:22', '', '', '2020-01-03 10:44:22', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p>～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="background-color: #e03e2d;">&nbsp;这是测</span>试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1577698397739, 1577698397739, 0, '', '2020-01-03 11:11:30', '', '', '2020-01-03 11:11:30', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p style="text-align: center;">￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="background-color: #e03e2d;">&nbsp;这是测</span>试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1578390820084, 1578390820084, 0, '', '2020-01-07 17:56:58', '', '', '2020-01-07 17:56:58', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p style="text-align: center;"><strong><em>分页测试分页测试分页测试分页测试分页测试分页测试分页测试分页测试分页测试</em></strong></p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="background-color: #e03e2d;">&nbsp;这是测</span>试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，<span style="background-color: #fbeeb8;">这是测试内容</span>，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1578469675979, 1578469675979, 0, '', '2020-01-10 17:26:30', '', '', '2020-01-10 17:26:30', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p style="text-align: center;"><strong><em>分页测试分页测试分页测试分页测试分页测试分页测试分页测试分页测试分页测</em></strong></p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="background-color: #e03e2d;">&nbsp;这是测</span>试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; <span style="background-color: #f1c40f;">这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容</span>。</p>', ''),
	(1578471402248, 1578471402248, 0, '', '2020-01-10 17:12:02', '', '', '2020-01-10 17:12:02', '<h1 style="text-align: center;"><strong>XXXX医院</strong></h1>\n<p>1577160124447</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <span style="background-color: #e03e2d;">&nbsp;这是测</span>试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，<span style="background-color: #bfedd2;">这是测试内容</span>，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p><span style="background-color: #e42020;">2.历史描述：</span></p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1578485916056, 1578485916056, 0, '', '2020-01-10 20:08:44', '', '', '2020-01-10 20:08:44', '<h1 style="text-align: center;"><span style="background-color: #e42020;"><strong>XXXX医院</strong></span></h1>\n<p>1577159650141&nbsp;</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是<strong>测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，</strong>这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(1578658203752, 1578658203752, 0, '', '2020-01-10 20:08:44', '', '', '2020-01-10 20:08:44', '<h1 style="text-align: center;"><span style="background-color: #e42020;"><strong>XXXX医院</strong></span></h1>\n<p>1577159650141&nbsp;</p>\n<p>1.病情描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是<strong>测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，</strong>这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，<span style="background-color: #e42020;">这是测试内容</span>，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试<span style="background-color: #e42020;">内容，这是测</span>试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这<span style="background-color: #e42020;">是测试内容</span>，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是<span style="background-color: #e42020;">测试内容，</span>这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，<span style="background-color: #e42020;">这是测</span>试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，<span style="background-color: #e42020;">这是测试内容，</span>这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', ''),
	(3092356220974197000, 3092356220974197000, 0, '', '2019-12-27 22:31:44', '', '', '2019-12-27 22:31:44', '<h1 style="text-align: center;"><span style="background-color: #e03e2d;">XXXX医院</span></h1>\n<p>3092356220974197000</p>\n<p>1.<span style="background-color: #e42020;">病情</span>描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>2.历史描述：</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>\n<p>3.结论：</p>\n<p>&nbsp; &nbsp; &nbsp; 这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容，这是测试内容。</p>', '');
/*!40000 ALTER TABLE `h_report` ENABLE KEYS */;

-- Dumping structure for table hit.h_user
CREATE TABLE IF NOT EXISTS `h_user` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table hit.h_user: ~0 rows (approximately)
/*!40000 ALTER TABLE `h_user` DISABLE KEYS */;
INSERT INTO `h_user` (`id`, `username`, `password`) VALUES
	(1, 'admin', 'admin');
/*!40000 ALTER TABLE `h_user` ENABLE KEYS */;

-- Dumping structure for table hit.user
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Dumping data for table hit.user: ~0 rows (approximately)
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`id`, `username`, `password`) VALUES
	(1, 'admin\r\n', 'admin');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
