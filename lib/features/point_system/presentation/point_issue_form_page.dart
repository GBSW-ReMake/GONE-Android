import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/point_system_notifier.dart';
import '../domain/point_system.dart';

class PointIssueFormPage extends ConsumerStatefulWidget {
  const PointIssueFormPage({super.key, required this.student});
  final PointStudent student;
  @override
  ConsumerState<PointIssueFormPage> createState() => _PointIssueFormPageState();
}

class _PointIssueFormPageState extends ConsumerState<PointIssueFormPage> {
  late PointIssueDraft _draft;
  late final TextEditingController _memo;
  @override void initState() { super.initState(); _draft = ref.read(pointSystemProvider).drafts[widget.student.id] ?? const PointIssueDraft(); _memo = TextEditingController(text: _draft.memo); }
  @override void dispose() { _memo.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(backgroundColor: const Color(0xFFF3F5F9), body: SafeArea(child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children:[IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.chevron_left,size:22)),const Expanded(child:Center(child:Text('상벌점 발급',style:TextStyle(fontSize:21,fontWeight:FontWeight.w800,color:GoneColors.deepNavy))),),const SizedBox(width:48)]),
        const SizedBox(height:16), Container(height:44,alignment:Alignment.centerLeft,padding:const EdgeInsets.symmetric(horizontal:16),decoration:BoxDecoration(color:const Color(0xFFE1F3EC),borderRadius:BorderRadius.circular(8)),child:Text('✓ ${widget.student.name} 학생을 추가했습니다.',style:const TextStyle(color:GoneColors.success,fontWeight:FontWeight.w600))),
        const SizedBox(height:12), Container(height:56,padding:const EdgeInsets.symmetric(horizontal:18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),child:Row(children:[Text(widget.student.name,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w800)),const SizedBox(width:9),Text(widget.student.info,style:const TextStyle(fontSize:12,color:Color(0xFF667085))),const Spacer(),IconButton(onPressed:(){ref.read(pointSystemProvider.notifier).removeStudent(widget.student);Navigator.pop(context);},icon:const Icon(Icons.close,size:18))])),
        const SizedBox(height:12), Row(children:[Expanded(child:_kind(PointKind.reward)),const SizedBox(width:12),Expanded(child:_kind(PointKind.penalty))]),
        const SizedBox(height:18), const Text('발급 항목',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:GoneColors.deepNavy)),const SizedBox(height:10), DropdownButtonFormField<int>(value:_draft.points,items:const [DropdownMenuItem(value:2,child:Text('[2점] 학교 홍보 활동에 성실히 참여한 학생')),DropdownMenuItem(value:1,child:Text('[1점] 교내 행사에 참여한 학생')),DropdownMenuItem(value:3,child:Text('[3점] 수업시간 교사지시 불이행'))],onChanged:(v){if(v==null)return;setState(()=>_draft=_draft.copyWith(points:v,item:v==2?'학교 홍보 활동에 성실히 참여한 학생':v==1?'교내 행사에 참여한 학생':'수업시간 교사지시 불이행'));},decoration:_decoration()),
        const SizedBox(height:16),const Text('메모',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:GoneColors.deepNavy)),const SizedBox(height:10),TextField(controller:_memo,maxLines:3,decoration:_decoration(hint:'선택 사항')),
        const Spacer(), Row(children:[OutlinedButton(onPressed:(){ref.read(pointSystemProvider.notifier).clear();Navigator.pop(context);},style:OutlinedButton.styleFrom(minimumSize:const Size(112,52),foregroundColor:GoneColors.error,side:const BorderSide(color:GoneColors.error)),child:const Text('전체 삭제')),const SizedBox(width:12),Expanded(child:FilledButton(onPressed:(){ref.read(pointSystemProvider.notifier).saveDraft(widget.student,_draft.copyWith(memo:_memo.text));Navigator.pop(context);},style:FilledButton.styleFrom(minimumSize:const Size.fromHeight(52),backgroundColor:GoneColors.primary),child:const Text('명단 추가하기')))])
      ]),
    ))),
  );
  Widget _kind(PointKind kind){final selected=_draft.kind==kind;final color=kind==PointKind.reward?GoneColors.success:GoneColors.error;return OutlinedButton(onPressed:()=>setState(()=>_draft=_draft.copyWith(kind:kind)),style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(54),foregroundColor:selected?Colors.white:color,backgroundColor:selected?color:Colors.white,side:BorderSide(color:color)),child:Text(kind.label,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800)));}
  InputDecoration _decoration({String? hint})=>InputDecoration(hintText:hint,filled:true,fillColor:Colors.white,contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:14),border:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:const BorderSide(color:Color(0xFFD8DEE8))));
}
