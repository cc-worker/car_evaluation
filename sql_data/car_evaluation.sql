/*
Navicat MySQL Data Transfer

Source Server         : 192.168.20.11
Source Server Version : 50621
Source Host           : 192.168.20.11:3306
Source Database       : car_evaluation

Target Server Type    : MYSQL
Target Server Version : 50621
File Encoding         : 65001

Date: 2019-01-07 16:05:46
*/
USE car_evaluation;

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES ('1', 'Can add log entry', '1', 'add_logentry');
INSERT INTO `auth_permission` VALUES ('2', 'Can change log entry', '1', 'change_logentry');
INSERT INTO `auth_permission` VALUES ('3', 'Can delete log entry', '1', 'delete_logentry');
INSERT INTO `auth_permission` VALUES ('4', 'Can add permission', '2', 'add_permission');
INSERT INTO `auth_permission` VALUES ('5', 'Can change permission', '2', 'change_permission');
INSERT INTO `auth_permission` VALUES ('6', 'Can delete permission', '2', 'delete_permission');
INSERT INTO `auth_permission` VALUES ('7', 'Can add group', '3', 'add_group');
INSERT INTO `auth_permission` VALUES ('8', 'Can change group', '3', 'change_group');
INSERT INTO `auth_permission` VALUES ('9', 'Can delete group', '3', 'delete_group');
INSERT INTO `auth_permission` VALUES ('10', 'Can add user', '4', 'add_user');
INSERT INTO `auth_permission` VALUES ('11', 'Can change user', '4', 'change_user');
INSERT INTO `auth_permission` VALUES ('12', 'Can delete user', '4', 'delete_user');
INSERT INTO `auth_permission` VALUES ('13', 'Can add content type', '5', 'add_contenttype');
INSERT INTO `auth_permission` VALUES ('14', 'Can change content type', '5', 'change_contenttype');
INSERT INTO `auth_permission` VALUES ('15', 'Can delete content type', '5', 'delete_contenttype');
INSERT INTO `auth_permission` VALUES ('16', 'Can add session', '6', 'add_session');
INSERT INTO `auth_permission` VALUES ('17', 'Can change session', '6', 'change_session');
INSERT INTO `auth_permission` VALUES ('18', 'Can delete session', '6', 'delete_session');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_user
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for car_brand
-- ----------------------------
DROP TABLE IF EXISTS `car_brand`;
CREATE TABLE `car_brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `brand_name` varchar(50) DEFAULT NULL COMMENT '品牌名称',
  `name_initial` varchar(5) DEFAULT NULL COMMENT '品牌名称首字母',
  `index_id` varchar(10) DEFAULT NULL COMMENT '车系索引编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of car_brand
-- ----------------------------
INSERT INTO `car_brand` VALUES ('1', '阿尔法·罗密欧', 'A', '92');
INSERT INTO `car_brand` VALUES ('2', '奥迪', 'A', '9');
INSERT INTO `car_brand` VALUES ('3', '阿斯顿·马丁', 'A', '97');
INSERT INTO `car_brand` VALUES ('4', '比亚迪', 'B', '15');
INSERT INTO `car_brand` VALUES ('5', '北汽绅宝', 'B', '195');
INSERT INTO `car_brand` VALUES ('6', '宝马', 'B', '3');
INSERT INTO `car_brand` VALUES ('7', '巴博斯', 'B', '172');
INSERT INTO `car_brand` VALUES ('8', '本田', 'B', '26');
INSERT INTO `car_brand` VALUES ('9', '保斐利', 'B', '184');
INSERT INTO `car_brand` VALUES ('10', '别克', 'B', '127');
INSERT INTO `car_brand` VALUES ('11', '北汽新能源', 'B', '216');
INSERT INTO `car_brand` VALUES ('12', '北汽幻速', 'B', '211');
INSERT INTO `car_brand` VALUES ('13', '宾利', 'B', '85');
INSERT INTO `car_brand` VALUES ('14', '标致', 'B', '5');
INSERT INTO `car_brand` VALUES ('15', '北汽威旺', 'B', '168');
INSERT INTO `car_brand` VALUES ('16', '奔腾', 'B', '59');
INSERT INTO `car_brand` VALUES ('17', '保时捷', 'B', '82');
INSERT INTO `car_brand` VALUES ('18', '奔驰', 'B', '2');
INSERT INTO `car_brand` VALUES ('19', '北京', 'B', '163');
INSERT INTO `car_brand` VALUES ('20', '宝骏', 'B', '157');
INSERT INTO `car_brand` VALUES ('21', '北汽制造', 'B', '14');
INSERT INTO `car_brand` VALUES ('22', '成功', 'C', '221');
INSERT INTO `car_brand` VALUES ('23', '昌河', 'C', '129');
INSERT INTO `car_brand` VALUES ('24', '长城', 'C', '21');
INSERT INTO `car_brand` VALUES ('25', '长安轿车', 'C', '136');
INSERT INTO `car_brand` VALUES ('26', '长安商用', 'C', '159');
INSERT INTO `car_brand` VALUES ('27', '东风风行', 'D', '115');
INSERT INTO `car_brand` VALUES ('28', '东南', 'D', '29');
INSERT INTO `car_brand` VALUES ('29', '东风·郑州日产', 'D', '235');
INSERT INTO `car_brand` VALUES ('30', '大宇', 'D', '106');
INSERT INTO `car_brand` VALUES ('31', '道奇', 'D', '113');
INSERT INTO `car_brand` VALUES ('32', '东风', 'D', '27');
INSERT INTO `car_brand` VALUES ('33', '东风风神', 'D', '141');
INSERT INTO `car_brand` VALUES ('34', '东风风光', 'D', '253');
INSERT INTO `car_brand` VALUES ('35', '大通MAXUS', 'D', '165');
INSERT INTO `car_brand` VALUES ('36', 'DS', 'D', '179');
INSERT INTO `car_brand` VALUES ('37', '东风小康', 'D', '205');
INSERT INTO `car_brand` VALUES ('38', '东风风度', 'D', '197');
INSERT INTO `car_brand` VALUES ('39', '大众', 'D', '8');
INSERT INTO `car_brand` VALUES ('40', '福迪', 'F', '67');
INSERT INTO `car_brand` VALUES ('41', '丰田', 'F', '7');
INSERT INTO `car_brand` VALUES ('42', '飞驰商务车', 'F', '199');
INSERT INTO `car_brand` VALUES ('43', '福田', 'F', '128');
INSERT INTO `car_brand` VALUES ('44', '福汽启腾', 'F', '208');
INSERT INTO `car_brand` VALUES ('45', '福特', 'F', '17');
INSERT INTO `car_brand` VALUES ('46', '菲亚特', 'F', '40');
INSERT INTO `car_brand` VALUES ('47', '法拉利', 'F', '91');
INSERT INTO `car_brand` VALUES ('48', 'GMC', 'G', '109');
INSERT INTO `car_brand` VALUES ('49', '广汽中兴', 'G', '252');
INSERT INTO `car_brand` VALUES ('50', '广汽吉奥', 'G', '63');
INSERT INTO `car_brand` VALUES ('51', '光冈', 'G', '110');
INSERT INTO `car_brand` VALUES ('52', '广汽传祺', 'G', '147');
INSERT INTO `car_brand` VALUES ('53', '观致汽车', 'G', '182');
INSERT INTO `car_brand` VALUES ('54', '恒天汽车', 'H', '181');
INSERT INTO `car_brand` VALUES ('55', '黄海', 'H', '52');
INSERT INTO `car_brand` VALUES ('56', '海马', 'H', '32');
INSERT INTO `car_brand` VALUES ('57', '华泰', 'H', '112');
INSERT INTO `car_brand` VALUES ('58', '海马商用车', 'H', '149');
INSERT INTO `car_brand` VALUES ('59', '红旗', 'H', '58');
INSERT INTO `car_brand` VALUES ('60', '华普', 'H', '44');
INSERT INTO `car_brand` VALUES ('61', '海格', 'H', '170');
INSERT INTO `car_brand` VALUES ('62', '哈弗', 'H', '196');
INSERT INTO `car_brand` VALUES ('63', '悍马', 'H', '108');
INSERT INTO `car_brand` VALUES ('64', '华颂', 'H', '225');
INSERT INTO `car_brand` VALUES ('65', '华泰新能源', 'H', '251');
INSERT INTO `car_brand` VALUES ('66', '哈飞', 'H', '31');
INSERT INTO `car_brand` VALUES ('67', '九龙', 'J', '152');
INSERT INTO `car_brand` VALUES ('68', '江淮', 'J', '35');
INSERT INTO `car_brand` VALUES ('69', '捷豹', 'J', '98');
INSERT INTO `car_brand` VALUES ('70', '江南', 'J', '38');
INSERT INTO `car_brand` VALUES ('71', '江铃集团轻汽', 'J', '224');
INSERT INTO `car_brand` VALUES ('72', 'Jeep', 'J', '4');
INSERT INTO `car_brand` VALUES ('73', '金杯', 'J', '39');
INSERT INTO `car_brand` VALUES ('74', '吉利汽车', 'J', '34');
INSERT INTO `car_brand` VALUES ('75', '江铃', 'J', '37');
INSERT INTO `car_brand` VALUES ('76', '科瑞斯的', 'K', '218');
INSERT INTO `car_brand` VALUES ('77', '康迪', 'K', '241');
INSERT INTO `car_brand` VALUES ('78', '卡威', 'K', '213');
INSERT INTO `car_brand` VALUES ('79', '凯迪拉克', 'K', '107');
INSERT INTO `car_brand` VALUES ('80', '开瑞', 'K', '150');
INSERT INTO `car_brand` VALUES ('81', '卡尔森', 'K', '188');
INSERT INTO `car_brand` VALUES ('82', '凯翼', 'K', '220');
INSERT INTO `car_brand` VALUES ('83', '克莱斯勒', 'K', '51');
INSERT INTO `car_brand` VALUES ('84', '莲花', 'L', '146');
INSERT INTO `car_brand` VALUES ('85', '林肯', 'L', '95');
INSERT INTO `car_brand` VALUES ('86', '雷丁电动', 'L', '229');
INSERT INTO `car_brand` VALUES ('87', '兰博基尼', 'L', '86');
INSERT INTO `car_brand` VALUES ('88', '猎豹汽车', 'L', '153');
INSERT INTO `car_brand` VALUES ('89', '路虎', 'L', '96');
INSERT INTO `car_brand` VALUES ('90', '陆风', 'L', '36');
INSERT INTO `car_brand` VALUES ('91', '雷诺', 'L', '99');
INSERT INTO `car_brand` VALUES ('92', '力帆', 'L', '76');
INSERT INTO `car_brand` VALUES ('93', '铃木', 'L', '16');
INSERT INTO `car_brand` VALUES ('94', '雷克萨斯', 'L', '94');
INSERT INTO `car_brand` VALUES ('95', '路特斯', 'L', '83');
INSERT INTO `car_brand` VALUES ('96', '理念', 'L', '166');
INSERT INTO `car_brand` VALUES ('97', '劳斯莱斯', 'L', '80');
INSERT INTO `car_brand` VALUES ('98', '美亚', 'M', '55');
INSERT INTO `car_brand` VALUES ('99', 'MINI', 'M', '81');
INSERT INTO `car_brand` VALUES ('100', '玛莎拉蒂', 'M', '93');
INSERT INTO `car_brand` VALUES ('101', '马自达', 'M', '18');
INSERT INTO `car_brand` VALUES ('102', 'MG', 'M', '79');
INSERT INTO `car_brand` VALUES ('103', '迈巴赫', 'M', '88');
INSERT INTO `car_brand` VALUES ('104', '迈凯伦', 'M', '183');
INSERT INTO `car_brand` VALUES ('105', '纳智捷', 'N', '155');
INSERT INTO `car_brand` VALUES ('106', '讴歌', 'O', '84');
INSERT INTO `car_brand` VALUES ('107', '欧宝', 'O', '104');
INSERT INTO `car_brand` VALUES ('108', '欧朗', 'O', '171');
INSERT INTO `car_brand` VALUES ('109', '欧联', 'O', '243');
INSERT INTO `car_brand` VALUES ('110', '庆铃', 'Q', '43');
INSERT INTO `car_brand` VALUES ('111', '启辰', 'Q', '156');
INSERT INTO `car_brand` VALUES ('112', '奇瑞', 'Q', '42');
INSERT INTO `car_brand` VALUES ('113', '起亚', 'Q', '28');
INSERT INTO `car_brand` VALUES ('114', '荣威', 'R', '78');
INSERT INTO `car_brand` VALUES ('115', '日产', 'R', '30');
INSERT INTO `car_brand` VALUES ('116', '瑞麒', 'R', '142');
INSERT INTO `car_brand` VALUES ('117', '山姆', 'S', '209');
INSERT INTO `car_brand` VALUES ('118', '陕汽通家', 'S', '169');
INSERT INTO `car_brand` VALUES ('119', 'smart', 'S', '89');
INSERT INTO `car_brand` VALUES ('120', '上喆汽车', 'S', '244');
INSERT INTO `car_brand` VALUES ('121', '双环', 'S', '50');
INSERT INTO `car_brand` VALUES ('122', '赛麟SALEEN', 'S', '239');
INSERT INTO `car_brand` VALUES ('123', '斯柯达', 'S', '10');
INSERT INTO `car_brand` VALUES ('124', '三菱', 'S', '25');
INSERT INTO `car_brand` VALUES ('125', 'SPIRRA', 'S', '162');
INSERT INTO `car_brand` VALUES ('126', '双龙', 'S', '102');
INSERT INTO `car_brand` VALUES ('127', '斯巴鲁', 'S', '111');
INSERT INTO `car_brand` VALUES ('128', '萨博', 'S', '103');
INSERT INTO `car_brand` VALUES ('129', '世爵', 'S', '137');
INSERT INTO `car_brand` VALUES ('130', '腾势', 'T', '175');
INSERT INTO `car_brand` VALUES ('131', '特斯拉', 'T', '189');
INSERT INTO `car_brand` VALUES ('132', '通田', 'T', '56');
INSERT INTO `car_brand` VALUES ('133', '泰卡特', 'T', '202');
INSERT INTO `car_brand` VALUES ('134', '天马', 'T', '54');
INSERT INTO `car_brand` VALUES ('135', '万丰', 'W', '46');
INSERT INTO `car_brand` VALUES ('136', '五十铃', 'W', '132');
INSERT INTO `car_brand` VALUES ('137', '潍柴英致', 'W', '207');
INSERT INTO `car_brand` VALUES ('138', '沃尔沃', 'W', '19');
INSERT INTO `car_brand` VALUES ('139', '五菱', 'W', '48');
INSERT INTO `car_brand` VALUES ('140', '威麟', 'W', '140');
INSERT INTO `car_brand` VALUES ('141', '威兹曼', 'W', '186');
INSERT INTO `car_brand` VALUES ('142', '雪铁龙', 'X', '6');
INSERT INTO `car_brand` VALUES ('143', '雪佛兰', 'X', '49');
INSERT INTO `car_brand` VALUES ('144', '西雅特', 'X', '87');
INSERT INTO `car_brand` VALUES ('145', '新大地', 'X', '65');
INSERT INTO `car_brand` VALUES ('146', '现代', 'X', '13');
INSERT INTO `car_brand` VALUES ('147', '新雅途', 'X', '62');
INSERT INTO `car_brand` VALUES ('148', '新凯', 'X', '71');
INSERT INTO `car_brand` VALUES ('149', '星客特', 'X', '174');
INSERT INTO `car_brand` VALUES ('150', '野马汽车', 'Y', '138');
INSERT INTO `car_brand` VALUES ('151', '永源', 'Y', '75');
INSERT INTO `car_brand` VALUES ('152', '驭胜', 'Y', '258');
INSERT INTO `car_brand` VALUES ('153', '仪征', 'Y', '47');
INSERT INTO `car_brand` VALUES ('154', '一汽', 'Y', '53');
INSERT INTO `car_brand` VALUES ('155', '英菲尼迪', 'Y', '100');
INSERT INTO `car_brand` VALUES ('156', '中客华北', 'Z', '64');
INSERT INTO `car_brand` VALUES ('157', '知豆', 'Z', '233');
INSERT INTO `car_brand` VALUES ('158', '中兴', 'Z', '33');
INSERT INTO `car_brand` VALUES ('159', '众泰', 'Z', '77');
INSERT INTO `car_brand` VALUES ('160', '中华', 'Z', '60');

-- ----------------------------
-- Table structure for car_models
-- ----------------------------
DROP TABLE IF EXISTS `car_models`;
CREATE TABLE `car_models` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `models_name` varchar(100) DEFAULT NULL COMMENT '车型名称',
  `price` float DEFAULT '0' COMMENT '新车价格',
  `year` int(11) DEFAULT '0' COMMENT '出厂年份',
  `emission` varchar(10) DEFAULT '0' COMMENT '排量',
  `index_id` varchar(10) DEFAULT NULL COMMENT '车型评估url索引编号',
  `car_series_id` int(11) DEFAULT '1' COMMENT '车系',
  PRIMARY KEY (`id`),
  KEY `car_series_id` (`car_series_id`),
  CONSTRAINT `car_models_ibfk_1` FOREIGN KEY (`car_series_id`) REFERENCES `car_series` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of car_models
-- ----------------------------

-- ----------------------------
-- Table structure for chezhiwang
-- ----------------------------
DROP TABLE IF EXISTS `chezhiwang`;
CREATE TABLE `chezhiwang` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_site` smallint(6) NOT NULL,
  `code` int(30) NOT NULL,
  `brand` varchar(50) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `report_place` varchar(20) DEFAULT NULL,
  `demand` varchar(255) DEFAULT NULL,
  `report_time` date DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `car_class` varchar(30) DEFAULT NULL,
  `car_type` varchar(30) DEFAULT NULL,
  `reporter` varchar(30) DEFAULT NULL,
  `detail` text,
  `typical_fault` varchar(30) DEFAULT NULL,
  `repair_num` int(11) DEFAULT NULL COMMENT '涉及的“维修”以及与其语义相关的词 次数',
  `safety_num` int(11) DEFAULT NULL COMMENT '“自燃”、“爆炸”“人身安全”以及语义相关等词汇的词频',
  `injury_num` int(11) DEFAULT NULL COMMENT '提取“伤亡”等信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=112821 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of chezhiwang
-- ----------------------------
INSERT INTO `chezhiwang` VALUES ('111', '1', '111', '丰田', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '雷克萨斯CT', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '变速器', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('112', '1', '112', '丰田', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '雷克萨斯CT', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '变速器', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('113', '1', '113', '丰田', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '雷克萨斯CT', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '发动机', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('114', '1', '114', '丰田', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '雷克萨斯CT', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '变速器', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('115', '1', '115', '丰田', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '雷克萨斯CT', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '变速器', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('222', '1', '222', '丰田', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '雷克萨斯CT', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '发动机,变速器', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('333', '1', '333', '丰田', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '雷克萨斯CT', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '变速器', '1', '1', '0');
INSERT INTO `chezhiwang` VALUES ('444', '1', '444', '丰田', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '雷克萨斯CT', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '变速器', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('555', '1', '555', '丰田', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '雷克萨斯CT', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '变速器', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('666', '1', '666', '丰田', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '雷克萨斯CT', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '变速器', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('3728', '0', '104435', 'Jeep', '吉普自由光变速箱挂不上挡行驶中熄火', '', '', '2010-04-01', '', '自由光', '2014款 2.4L 自动 高性能版 5座', '', '		投诉内容：  							购买三个月出现行驶中自动熄火，变速箱没有反应，而且还有自动加速的问题。在等红灯时N挡放回D挡踩油门不走，这时会听到变速箱里有敲击齿轮的声音，然后必须把档杆放回P再回到D挡才可以正常行驶。行驶中自动熄火，重新启动才可以使用。  						', '发动机,变速器', '2', '0', '0');
INSERT INTO `chezhiwang` VALUES ('19663', '1', '122580', 'Jeep', '吉普自由光变速箱漏油更换后不给延长质保', '', '', '2010-06-05', '', '自由光（进口）', ' 2014款 2.4L 自动 豪华版', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201601/06/201601062148098613_sst.jpg\" /><img src=\"http://img.12365auto.com/c/201601/06/201601062148192838_sst.jpg\" /><img src=\"http://img.12365auto.com/c/201601/06/201601062148241198_sst.jpg\" /><img src=\"http://img.12365auto.com/c/201601/06/201601062150514464_sst.jpg\" /></p><p>本人于2014年2月购买了一辆全新自由光用车期间变速箱顿挫明显，2015年12月进店更换半轴时发现变速箱漏油，厂家给更换了一台变速箱总成但却不肯按新换变速箱的时间延长质保说要按整车质保，如果我的车剩几个月就脱保那新换的变速箱也就质保几个月就脱保，我觉得不能接受，厂家发来的变速箱明明有3年10万公里的质保卡为什么就不给保而非要按整车质保，这太不合理，如果都按整车质保每辆车都有三包卡就不用弄什么变速箱的质保卡，我相信每个变速箱出厂都有固定的质保时间，而不是看换到哪一个车上而决定它的剩余质保时间，希望有关单位能注意这个问题还消费者一个公道。</p>\r\n						', '服务态度,其他', '1', '0', '0');
INSERT INTO `chezhiwang` VALUES ('22142', '0', '12769', 'Jeep', 'JEEP指南者新车车轮脱落导车辆致撞击起火', '', '', '2010-10-05', '', '指南者', '2012款 指南者 2.4 CVT 都市版', '', '		投诉内容：  							2011年11月6日在河北天道汽车贸易有限公司购买的新款指南者，次日行驶中车轮脱落导致车撞击起大火整车燃烧。经销商态度恶劣不予解决，希望能得到你们的帮助。车牌当时是临时的。  						', '车身附件及电器,其他', '2', '1', '0');
INSERT INTO `chezhiwang` VALUES ('22354', '0', '12981', 'Jeep', 'JEEP指南者制动系统异响问题', '', '', '2011-02-05', '', '指南者', '2012款 指南者 2.4 CVT 都市版', '', '		投诉内容：  							2012年2月在吉林省长春市永成4S店购买2012款指南者。4月份发现行走过程中制动系统有摩擦发出的响声。去4S店检测说美国克莱斯勒公司告诉的属于正常现象。4S店说上报美国克莱斯勒公司等候回答。强烈要求更换制动系统。赔偿损失。  						', '制动系统', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('27314', '0', '18046', 'Jeep', 'JEEP吉普指南者马牌轮胎凹陷问题', '', '', '2012-06-05', '', '指南者', '2010款 指南者Compass 2.4 AT/MT 运动版', '', '		投诉内容：  							大概行驶1800公里左右就发现四个轮胎都有凹痕，跟销售商沟通后被告知是轮胎生产工艺所致，拒绝调换，但我请教其他汽修行业师傅都认为存在安全隐患。  						', '轮胎', '2', '1', '0');
INSERT INTO `chezhiwang` VALUES ('44870', '0', '36446', 'Jeep', 'JEEP指南者三元催化堵塞', '', '', '2012-10-05', '', '指南者', '2010款 指南者Compass 2.4 AT/MT 运动版', '', '		投诉内容：  							本人于2011年3月购买了这台10款的吉普指南者，购买时由于已先在网上了解这款车的08、09款均出现过三元催化质量问题及设计缺陷，当时售前人员告诉我10款的三元催化已经得到解决并且可以使用国内的93号汽油。今天8月初，我驾车前往青海自驾游途中发现车辆行驶无力，高速公路行驶无法超过110公里，当时首先怀疑是CVT无级变速箱齿轮打滑了，后面网上查询后知道是由于三元催化堵塞至使排气不畅造成的原因。于是我打电话到城市车辆克莱斯勒4S店向售后人员反映该情况时，售后人员马上就指出是由于三元催化堵塞了，需要更换。由于吉普指南者的质保时间为3年8万公里，我这辆车均没有超过质保期限，于是我提出索赔，可4S店的工作人员告诉我，由于我国汽油标准不够，所以必须添加97号汽油，因我平时加的是93号汽油且因油品问题，不在理赔范围，必须自己花钱更换，更换的费用大约6000元左右。可是当初我购买时售前人员并没有向我告之必须要加97号汽油，并且在该车辆的使用手册中也明确注明添加93号及以上汽油即可，该手册上并未注明使用的93号汽油不包含中国在内。本人于是又在网上了解到，吉普指南者这款车型的三元催化存在设计上的缺陷，参考网站http://baike.cheshi.com/12354.html，并非由于单纯使用93号汽油所造成。本人此次申诉观点主要有以下几条：1.克莱斯勒公司既然已经意识到中国93号汽油品质问题会影响到车辆正常使用，为何还在对外宣传中又建议大家使用93号汽油；2.国际上对三元催化的质保公里数一般在10-20万左右，而国内给出的相关标准是8-10公里（说明国内已了解到国内汽油与国际汽油质量方面的差异，已把质保公里数降低了），而我的车辆在正常4S店保养的情况下，仅行驶到68000公里时就出现三元催化堵塞，并未到达国内三元催化损坏里程，也没有超过3年8万公里质保期；3.相关汽车专业网站对指南者三元催化设计给出的客观技术评定指出，08-10款的指南者均存在设计上的缺陷，而11款以后的指南者对三元催化器进行了新的改良。说明厂家已经意识到原老款车型中的三元催化并不适合中国93号汽油的使用，特此进行了改良。那为何对老款车辆所存在的设计缺陷而造成的三元催化提前损坏不承担义务和责任呢？4.克莱斯勒厂家说三元催化属于车辆易损件范畴，可是为何他们并未在用户使用手册及相关宣传册中充分说明呢？而且我查询了国家汽车行为相关的规定中，三元催化并未列入易损件范畴，那么既然克莱斯勒提供了3年8万公里以内的整车质保，在用户未超出质保范围之前，就应当提供质保服务，包括该车辆的三元催化。结合以上四点，本人投诉克莱斯勒公司指南者车辆在正常使用前提下三元催化提早损失的事实，并强烈要求克莱斯勒对本人车辆的三元催化进行免费更换。  						', '车身附件及电器', '1', '0', '0');
INSERT INTO `chezhiwang` VALUES ('47083', '0', '38793', 'Jeep', 'JEEP指南者新车有质量问题', '', '', '2012-12-05', '', '指南者', '2013款 指南者 2.4L CVT 炫黑导航版', '', '		投诉内容：  							2013年7月5号在浙江康桥润弛店买了一辆2013版2.4L炫黑导航版指南者，在8月底，公里数在2700公里的时候第一次出现汽车启动不起来，4S店派人上门维修，可是没有查出故障码，车子又自动好了。在使用了几天后，车子又再次出现同样启动不起来，第二次4S店上门维修，同样的查不出任何故障，车子又是自动好了。到9月15日，车子第三次出现同样的故障，这次4S店上门维修的时候查出了故障码，4S店答复是继电器的问题，重新给我换了继电器，车子又能开了。为了能彻底排查故障，第二天也就是9月16日，我又到4S店去让他们全面检查，检查结果告诉我就是继电器的问题，更换了就没问题了。可是，我从4S店回来两个小时后，车子第四次启动不起来，用拖车拖回4S店。这时候的公里数是2950KM。4S店现在说故障找到了，是跟继电器相连的一根铜线太短引起故障。但是又告知我引起车子不能启动的原因有很多种。因为已经连续出现四次问题了，而且4S店承认说这辆车是从别处调过来的，车子的具体情况连他们都不是很清楚，所以我对车子的质量问题很担忧。我要求4S店要么退车，要么对车子的质量做出保证。可是4S店拒绝退车，只对车子承诺不会由此线路引起的故障。车子的故障到底是不是由这个线路引起都不清楚，做这样的保证一点用都没有。现在车子还停在4S店。请贵网能关注此事，保障我们车主的权益。  						', '发动机', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('62413', '0', '55180', 'Jeep', 'Jeep吉普指南者后部底盘行驶中异响不断', '', '', '2013-01-01', '', '指南者', '2012款 指南者 2.0 CVT 豪华版', '', '		投诉内容：  							jeep2012款2.0CVT豪华版，今年2014年3月份起至今，车辆行驶中，加油和收油后，车身后部有不规则的异响，联系4S服务人员，得到回复是这车通病没有办法处理.所以投诉车辆生产商和4S服务店不作为，敷衍消费者的做法行为。同时强烈要求销售商给予处理问题，解决问题。  						', '前后桥及悬挂系统', '0', '1', '0');
INSERT INTO `chezhiwang` VALUES ('62610', '0', '55384', 'Jeep', 'Jeep吉普大切诺基出现严重发动机无法启动', '', '', '2013-04-01', '', '大切诺基（进口）', '2014款 3.6L 自动 旗舰尊悦版 5座', '', '		投诉内容：  							今年2月底购入3.6L大切，在3月14日发现空气悬挂挂不起来，后经4S店检测发现为悬挂系统的气管?损，后4S店以简单的二通阀连接暂时修好使用。5月4日，在申苏浙皖高速上行使时，突然车身抖动，并发现仪表盘档位从D档跳到N档，于是紧急将车滑行到最右侧紧急停靠带。后重新启动发动机时，发动机已无任何声响，发动不了。多次启动失败后，打4S店电话求助，仍无法启动，高速救援车将车拖至高速出口，三小时后4S派人现场检测维修，故障无法排除，最终通过克莱斯勒将拖到4S店检测维修。经过两天的检测，4S检测故障为发动机咬死，并发现发动机缸内有活塞碎片。现4S回复只更换新发动机，但作为消费者认为，此车在三月内行驶不到5000公里时，发生两次质量问题，尤其是车在高速运转时出现发动机故障，这种危及人身生命的严重的安全隐患，是无法接受的。我们要求4S店整车退换，并赔付相关经济损失！另，在这期间，本人在网上查到相关连接，http://www.jeepchina.net/forum.php?mod=viewthread&tid=112416我们认为L33公告所描述故障原因及现象与我们的故障现象相同，请相关部门协助调查！  						', '发动机', '1', '2', '0');
INSERT INTO `chezhiwang` VALUES ('70540', '0', '64250', 'Jeep', 'Jeep吉普指南者刹车出现呜呜的异响', '', '', '2013-06-01', '', '指南者', '2014款 2.4L 自动 四驱 运动版', '', '		投诉内容：  							Jeep指南者几乎每次起动倒车时踩刹车都会发出一种乌乌的响声,非常大声而且还持续到松开刹车,就联系了昆明那边的4S店客服热线他虽说每台指南者都会是有这种乌乌的响声而且还说每台指南者发出的这种异响都是正常的，听起来感觉一点责任都没，希望厂家能够尽快解决问题!那声音真的很烦。  						', '制动系统', '0', '2', '0');
INSERT INTO `chezhiwang` VALUES ('82961', '0', '78674', 'Jeep', '吉普自由光首保时发现变速器漏油', '', '', '2013-12-01', '', '自由光', '2014款 2.4L 自动 豪华版', '', '		投诉内容：  							去4S店车进行首保，检查发现变速箱上面油呼呼的，维修人员也说不清楚。希望能帮忙解决这个问题，因为维修可能要把车全部大拆，所以想换个新的。谢谢。  						', '变速器', '4', '2', '0');
INSERT INTO `chezhiwang` VALUES ('85149', '0', '81189', 'Jeep', '吉普大切诺基启动两秒就自动熄火', '', '', '2014-01-01', '', '大切诺基（进口）', '2011款 新大切诺基 3.6 AT 豪华版', '', '		投诉内容：  							车辆启动2秒钟自动熄火，然后再打马达，又着车2秒又熄火，就这种反复十几下才能着住车！刹车问题：车辆在行驶当中第一脚刹车完全踩不动（就像刹车踏板下面被什么东西顶住了一样）然后赶快放开，踩第二脚才能踩动（这个问题严重危险到我和他人的生命安全问题）我车现在出保了，上网查了一下，好多车友都是同样的故障，是属于通病，要求厂家给予索赔！  						', '发动机', '2', '2', '0');
INSERT INTO `chezhiwang` VALUES ('89110', '0', '85649', 'Jeep', '吉普自由客索赔的变速箱不是原厂的', '', '', '2014-10-01', '', '自由客', '2014款 2.0L CVT 运动增强版 5座', '', '		投诉内容：  							去年因变速箱问题去了几次当地4S店，直到15年3月份确认是变速箱问题！索赔！但是在索赔的过程中，发现索赔件根本不是原厂件！是那种再制造件！是国内的一家变速箱公司的部件（此公司就回收问题变速箱然后返修，而后又在卖出来的那种）克莱斯勒中国，根本就是在欺骗广大群众！希望汽车质量网能够跟进！帮忙处理！此时，如果没处理好！本人也会投诉去国家质量总局跟工商总局！希望质量网能一起帮忙！所有的更换过程跟证据，本人都有拍照下来！  						', '配件', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('92900', '0', '89907', 'Jeep', '吉普自由光变速器漏油自动加速', '', '', '2015-01-01', '', '自由光', '2014款 2.4L 自动 都市版', '', '		投诉内容：  							1.快到首保时发现变速器漏油很严重、打了4006500118后派拖车把车拖到昆明庞大泉天4s、检查后告知拨箱漏油需要更换总成、可都一个半月了也没消息、问了说在发配件就是没确切修好的时间2、还存在自动猛加速的情况。  						', '变速器', '2', '0', '0');
INSERT INTO `chezhiwang` VALUES ('93219', '0', '90264', 'Jeep', '吉普自由光变速箱无法换挡有冲击', '', '', '2015-05-01', '', '自由光', '2014款 3.2L 自动 Trailhawk', '', '		投诉内容：  							2015年1月购车，于2015年3月27日正常行使后在挪车时发生挂入倒挡没反应，熄火重新入挡后即刻发现从变速箱传出很大的冲击力，仪表盘上出现发动机故障图标及维修变速箱字样；出现故障后本人便不敢再移车，于是马上打克救援电话将车拖至4S店；到店后维修主管更新变速箱软件后重新试车，跑完一小段高速后问题依旧。现在的情况是:1、厂家决定更换变速箱，但需要45-60个工作日完成；需投诉的问题：1、3月不到的车为什么会出现这么严重的问题，而且在约提车二个月的时候已经出现异常，只是觉得问题不大。2、关注论坛得知此类情况已经在自由光身上已多次出现，厂家应该主动召回，因为同路虎极光一样是同一款ZF变速箱，应该向路虎一样召回并延保至7年24万公里。  						', '变速器', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('94007', '0', '91151', 'Jeep', '吉普自由光变速器高温故障灯亮', '', '', '2015-08-01', '', '自由光', '2014款 2.4L 自动 精锐版', '', '		投诉内容：  							喇叭坏了发件一个月，天窗坏了换电机三个月到的货且没修好，前天变速器坏了高温故障灯亮了，刹车瞬间失灵，油门自动加油，车内天花来回拆了3次天窗没修好可是走路有异响。现在车坏在深圳，厂家不提供代步车，和4s店沟通昨天说要两个月，今天我要求申请代步车又说一星期能修好，我该怎么办啊！  						', '变速器', '2', '0', '0');
INSERT INTO `chezhiwang` VALUES ('94098', '0', '91261', 'Jeep', '吉普自由光变速箱故障灯亮挂不上倒挡', '', '', '2016-01-01', '', '自由光', '2014款 2.4L 自动 豪华版', '', '		投诉内容：  							车辆挂不上倒挡，发动机声音变大，挂挡后顿挫，不顺，仪表盘显示变速器故障，进行维修。故障灯一直亮，开了2公里，熄火后再发动时不亮了。投诉：新车开了不足3000公里就出现变速箱故障，是明显的质量问题，到4S店答复是没有问题的。这么严重的问题，不是我一辆车出现，据说有不少车主在反映变速箱的问题。厂家为什么不拿出解决的办法，为什么不能延长保修期？难道中国的消费者是好坑的吗？  						', '变速器', '4', '0', '0');
INSERT INTO `chezhiwang` VALUES ('94195', '0', '91366', 'Jeep', '吉普大切诺基与同配置车型相比缺少功能', '', '', '2016-03-01', '', '大切诺基（进口）', '2014款 3.6L 自动 精英导航版 5座', '', '		投诉内容：  							本人购买的14款大切诺基3.6豪华导航版车型（3.0排量出后改叫精英导航版），与别的同配置车主对比，缺少1.自动防眩远光等2.日间行驶灯3.上下车自动调节悬架，以上功能别的车主都有，包括说明书，以及询问大切诺基官网客服也说有，一年前向4S店反应情况，一开始说可能是系统导航版本问题，升级未得到解决，后来又说可能是导航问题需更换导航总成，苦等几个月新导航换上又没有，说再去跟上面沟通，后来又说是他们有的这些车是厂家给他们勿装的，我这车没这配置的，由于别的车主以及看了展厅同版本新车以及试驾车都有，本要要求他们出具没有配置的有力依据，对方无法提供，又说尽量去帮我沟通，具体时间确定不了，花了同样的钱买了同配置，却没有相同的功能希望有关部门能出面解决。  						', '车身附件及电器 ', '4', '0', '0');
INSERT INTO `chezhiwang` VALUES ('96751', '0', '94317', 'Jeep', '吉普自由光行驶过程中变速箱锁死', '', '', '2016-10-01', '', '自由光', '2014款 2.4L 自动 豪华版', '', '		投诉内容：  							变速器已于3月底更换过1次了，5月3号又坏了，在高速路突然就被锁死了，好危险，两次都是这样。  						', '变速器', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('97031', '0', '94634', 'Jeep', '吉普指南者马牌轮胎凹陷', '', '', '2017-01-05', '', '指南者', '2015款 2.0L 自动 两驱运动版', '', '		投诉内容：  							提车后没几天，轮胎扎了个钉子，补胎的地方跟我说轮胎侧面有凹陷是轮胎质量问题找4S店。我找到4S店说明情况，他们也拍了照，说让我等消息。一个星期后接到4S店电话说我的轮胎来了让我把4个轮胎换下来送去做鉴定。我去4S店后服务人员告诉我轮胎给别人装掉了。我的轮胎就一直没有任何的处理回音一直到现在。我致电4S店售后，她们给我售后站长电话，电话一接通就讲了一堆道理和轮胎没问题的理由，我这个当事人连一句话都不让说。就这服务态度和效率能不投诉？  						', '轮胎', '0', '1', '1');
INSERT INTO `chezhiwang` VALUES ('100578', '0', '98771', 'Jeep', '吉普指南者多次出现行驶中熄火', '', '', '2017-04-05', '', '指南者', '2014款 2.4L 自动 四驱 舒适版 改款', '', '		投诉内容：  							6月4号在无锡市的中升4S店提了2015版的2.4升指南者舒适款。提车当天回家的路上，在行驶车速50Km/h左右，发动机突然熄火。车子停在了路中央长达10多分钟，期间多次尝试无法再次发动车子，最终发动后故障灯常亮。当天返回4S店做检查，将故障码清除后故障灯灭。第二天，在行驶了一段时间后，发动机在10km/h的车速下再次熄火，且无法再次发动。后送往4S店，在4S店中也无法再次发动，不得不手推到维修台进行检查。新车买来不到24小时，行驶不超过100公里，两次行驶中熄火，而且无法再次发动。为客户的生命财产安全带来严重危害，请有关部门给予高度重视。  						', '发动机', '0', '0', '0');
INSERT INTO `chezhiwang` VALUES ('112820', '1', '158832', 'Jeep', 'Jeep牧马人在4S店自燃 数月无人理赔', '', '', '2017-08-05', '', '牧马人', '2015款 3.6L  自动 四门版 Rubicon', '', '<p class=\"s_tp\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527251835_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527253395_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527254955_sst.jpg\"><img src=\"http://img.12365auto.com/c/201609/22/201609221527256203_sst.jpg\"></p>', '', '0', '0', '0');

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES ('1', 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES ('3', 'auth', 'group');
INSERT INTO `django_content_type` VALUES ('2', 'auth', 'permission');
INSERT INTO `django_content_type` VALUES ('4', 'auth', 'user');
INSERT INTO `django_content_type` VALUES ('5', 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES ('6', 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES ('1', 'contenttypes', '0001_initial', '2017-12-11 08:09:28.100315');
INSERT INTO `django_migrations` VALUES ('2', 'auth', '0001_initial', '2017-12-11 08:09:32.791690');
INSERT INTO `django_migrations` VALUES ('3', 'admin', '0001_initial', '2017-12-11 08:09:33.853268');
INSERT INTO `django_migrations` VALUES ('4', 'admin', '0002_logentry_remove_auto_add', '2017-12-11 08:09:33.908291');
INSERT INTO `django_migrations` VALUES ('5', 'contenttypes', '0002_remove_content_type_name', '2017-12-11 08:09:34.688663');
INSERT INTO `django_migrations` VALUES ('6', 'auth', '0002_alter_permission_name_max_length', '2017-12-11 08:09:35.074757');
INSERT INTO `django_migrations` VALUES ('7', 'auth', '0003_alter_user_email_max_length', '2017-12-11 08:09:35.440877');
INSERT INTO `django_migrations` VALUES ('8', 'auth', '0004_alter_user_username_opts', '2017-12-11 08:09:35.483906');
INSERT INTO `django_migrations` VALUES ('9', 'auth', '0005_alter_user_last_login_null', '2017-12-11 08:09:35.797519');
INSERT INTO `django_migrations` VALUES ('10', 'auth', '0006_require_contenttypes_0002', '2017-12-11 08:09:35.824302');
INSERT INTO `django_migrations` VALUES ('11', 'auth', '0007_alter_validators_add_error_messages', '2017-12-11 08:09:35.870780');
INSERT INTO `django_migrations` VALUES ('12', 'auth', '0008_alter_user_username_max_length', '2017-12-11 08:09:36.601573');
INSERT INTO `django_migrations` VALUES ('13', 'auth', '0009_alter_user_last_name_max_length', '2017-12-11 08:09:36.955065');
INSERT INTO `django_migrations` VALUES ('14', 'sessions', '0001_initial', '2017-12-11 08:09:37.274423');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of django_session
-- ----------------------------

-- ----------------------------
-- Table structure for tb_data_calculation
-- ----------------------------
DROP TABLE IF EXISTS `tb_data_calculation`;
CREATE TABLE `tb_data_calculation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_data_calculation
-- ----------------------------
INSERT INTO `tb_data_calculation` VALUES ('1', 'K最邻近算法', 'KNN', '1');
INSERT INTO `tb_data_calculation` VALUES ('2', '随机森林算法', 'RF', '1');
INSERT INTO `tb_data_calculation` VALUES ('3', '决策树算法', 'DT', '1');
INSERT INTO `tb_data_calculation` VALUES ('4', '朴素贝叶斯算法', 'NB', '1');
INSERT INTO `tb_data_calculation` VALUES ('5', '梯度提升决策树算法', 'GBDT', '1');
INSERT INTO `tb_data_calculation` VALUES ('6', '逻辑回归算法', 'LR', '1');
INSERT INTO `tb_data_calculation` VALUES ('7', 'SVM支持向量机算法', 'SVM', '1');

-- ----------------------------
-- Table structure for tb_data_model
-- ----------------------------
DROP TABLE IF EXISTS `tb_data_model`;
CREATE TABLE `tb_data_model` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `feature` varchar(255) DEFAULT NULL,
  `predict` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL COMMENT '1: 分类模型  2：预测模型',
  `status` int(255) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_data_model
-- ----------------------------
INSERT INTO `tb_data_model` VALUES ('1', 'model_分类', '1.5264512726e+12', 'detail', 'custom_type', '1', '1');
INSERT INTO `tb_data_model` VALUES ('2', 'model_预测', '1.5265234932e+12', 'car_series_id,emission,year', 'price', '2', '1');
INSERT INTO `tb_data_model` VALUES ('3', 'model_测试', '1.52696964652e+12', 'detail', 'custom_type', '1', '1');
INSERT INTO `tb_data_model` VALUES ('4', 'file_model_0107', '1.5468444866e+12', 'detail', 'custom_type', '1', '1');
INSERT INTO `tb_data_model` VALUES ('5', 'car_brand_0107', '1.54684574575e+12', 'brand_name', 'name_initial', '1', '1');

-- ----------------------------
-- Table structure for user_ini
-- ----------------------------
DROP TABLE IF EXISTS `user_ini`;
CREATE TABLE `user_ini` (
  `id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_ini
-- ----------------------------
