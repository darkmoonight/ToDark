import 'package:get/get.dart';
import 'package:todark/translation/ar_ar.dart';
import 'package:todark/translation/de_de.dart';
import 'package:todark/translation/en_us.dart';
import 'package:todark/translation/es_es.dart';
import 'package:todark/translation/fa_ir.dart';
import 'package:todark/translation/fr_fr.dart';
import 'package:todark/translation/it_it.dart';
import 'package:todark/translation/ru_ru.dart';
import 'package:todark/translation/zh_cn.dart';
import 'package:todark/translation/zh_tw.dart';
import 'package:todark/translation/tr_tr.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ru_RU': RuRu().messages,
        'en_US': EnUs().messages,
        'zh_CN': ZhCN().messages,
        'zh_TW': ZhTw().messages,
        'fa_IR': FaIr().messages,
        'ar_AR': ArAr().messages,
        'es_ES': EsEs().messages,
        'fr_FR': FrFr().messages,
        'de_DE': DeDe().messages,
        'it_IT': ItIt().messages,
        'tr_TR': TrTr().messages,
      };
}
