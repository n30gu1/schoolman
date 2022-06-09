import 'package:schoolman/date_converter.dart';

class School {
  String regionCode;
  String orgName;
  String schoolCode;
  String schoolName;
  String engSchoolName;
  SchoolType schoolType;
  String regionName;
  FoundationType foundationType;
  String postalCode;
  String address;
  String addressDetail;
  String telNumber;
  String homepageAddress;
  CoeduIDType coeduIdentifierType;
  String faxNumber;
  String? highSchoolTypeIdentifier;
  bool isBusinessSpecialClassExist;
  String highSchoolGeneralBusinessIdentifier;
  String? specialPurposeHighSchoolGroupType;
  DateTime foundationDate;
  DateTime foundationMemorialDate;
  DateTime lastModified;

  School(
      {required this.regionCode,
      required this.orgName,
      required this.schoolCode,
      required this.schoolName,
      required this.engSchoolName,
      required this.schoolType,
      required this.regionName,
      required this.foundationType,
      required this.postalCode,
      required this.address,
      required this.addressDetail,
      required this.telNumber,
      required this.homepageAddress,
      required this.coeduIdentifierType,
      required this.faxNumber,
      this.highSchoolTypeIdentifier,
      required this.isBusinessSpecialClassExist,
      required this.highSchoolGeneralBusinessIdentifier,
      this.specialPurposeHighSchoolGroupType,
      required this.foundationDate,
      required this.foundationMemorialDate,
      required this.lastModified});

  static School fromMap(Map map) {
    SchoolType schoolTypeConverter(String schoolType) {
      switch (schoolType) {
        case "고등학교":
          return SchoolType.high;
        case "중학교":
          return SchoolType.middle;
        case "초등학교":
          return SchoolType.elementary;
        default:
          return SchoolType.other;
      }
    }

    FoundationType foundationTypeConverter(String foundationType) {
      switch (foundationType) {
        case "사립":
          return FoundationType.private;
        case "공립":
          return FoundationType.public;
        default:
          return FoundationType.other;
      }
    }

    CoeduIDType coeduIDTypeConverter(String coeduIDType) {
      switch (coeduIDType) {
        case "남":
          return CoeduIDType.men;
        case "여":
          return CoeduIDType.women;
        default:
          return CoeduIDType.coeducation;
      }
    }

    return School(
        regionCode: map["ATPT_OFCDC_SC_CODE"],
        orgName: map["ATPT_OFCDC_SC_NM"],
        schoolCode: map["SD_SCHUL_CODE"],
        schoolName: map["SCHUL_NM"],
        engSchoolName: map["ENG_SCHUL_NM"],
        schoolType: schoolTypeConverter(map["SCHUL_KND_SC_NM"]),
        regionName: map["LCTN_SC_NM"],
        foundationType: foundationTypeConverter(map["FOND_SC_NM"]),
        postalCode: map["ORG_RDNZC"],
        address: map["ORG_RDNMA"],
        addressDetail: map["ORG_RDNDA"],
        telNumber: map["ORG_TELNO"],
        homepageAddress: map["HMPG_ADRES"],
        coeduIdentifierType: coeduIDTypeConverter(map["COEDU_SC_NM"]),
        faxNumber: map["ORG_FAXNO"],
        highSchoolTypeIdentifier: map["HS_SC_NM"],
        isBusinessSpecialClassExist:
            map["INDST_SPECL_CCCCL_EXST_YN"] == "Y" ? true : false,
        highSchoolGeneralBusinessIdentifier: map["HS_GNRL_BUSNS_SC_NM"],
        specialPurposeHighSchoolGroupType: map["SPCLY_PURPS_HS_ORD_NM"],
        foundationDate: map["FOND_YMD"].toString().convertFromyyyyMMdd(),
        foundationMemorialDate:
            map["FOAS_MEMRD"].toString().convertFromyyyyMMdd(),
        lastModified: map["LOAD_DTM"].toString().convertFromyyyyMMdd());
  }
}

enum SchoolType {
  elementary(0),
  middle(1),
  high(2),
  other(3);

  const SchoolType(this.code);
  final num code;
}

enum FoundationType {
  public("Public"),
  private("Private"),
  other("Other");

  const FoundationType(this.name);
  final String name;
}

enum CoeduIDType { men, women, coeducation }
