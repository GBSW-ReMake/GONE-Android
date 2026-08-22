import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/point_system_notifier.dart';
import '../domain/point_system.dart';

class PointSystemPage extends ConsumerStatefulWidget {
  const PointSystemPage({super.key});
  @override
  ConsumerState<PointSystemPage> createState() => _PointSystemPageState();
}

class _PointSystemPageState extends ConsumerState<PointSystemPage> {
  int _section = 0;
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pointSystemProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('상벌점 시스템', style: TextStyle(fontSize: 13, color: Color(0xFF667085))),
          const SizedBox(height: 6),
          const Text('상벌점 점수 발급', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: GoneColors.deepNavy)),
          const SizedBox(height: 22),
          _Tabs(selected: _section, onChanged: (value) => setState(() => _section = value)),
          const SizedBox(height: 22),
          Expanded(child: switch (_section) { 0 => _IssueTab(state: state), 1 => _HistoryTab(records: state.records), _ => _StatisticsTab(records: state.records) }),
        ]),
      )),
    );
  }
}

class _Tabs extends StatelessWidget { const _Tabs({required this.selected, required this.onChanged}); final int selected; final ValueChanged<int> onChanged;
  @override Widget build(BuildContext context) => Container(height: 48, padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFE9ECF1), borderRadius: BorderRadius.circular(16)), child: Row(children: List.generate(3, (i) { const labels=['점수발급','발급 내역','통계']; final active=selected==i; return Expanded(child: InkWell(onTap:()=>onChanged(i), borderRadius: BorderRadius.circular(12), child: Container(alignment: Alignment.center, decoration: BoxDecoration(color: active?Colors.white:Colors.transparent,borderRadius:BorderRadius.circular(12)), child: Text(labels[i], style: TextStyle(fontSize:14,fontWeight:active?FontWeight.w700:FontWeight.w500,color:active?GoneColors.primary:const Color(0xFF667085)))))); }))); }

class _IssueTab extends ConsumerWidget { const _IssueTab({required this.state}); final PointSystemState state;
  @override Widget build(BuildContext context, WidgetRef ref) { final c=ref.read(pointSystemProvider.notifier); return Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
    if(state.students.isEmpty) const Expanded(child: Center(child: Text('발급 대상자를 추가해 주세요', style: TextStyle(fontSize:20,fontWeight:FontWeight.w700,color:GoneColors.deepNavy)))) else Expanded(child: ListView(children:[const Text('발급 명단',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800)),const SizedBox(height:12),...state.students.map((s)=>Card(child:ListTile(title:Text(s.name,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text(s.info),trailing:IconButton(icon:const Icon(Icons.close),onPressed:()=>c.removeStudent(s))))])),
    OutlinedButton.icon(onPressed:()=>_pick(context,c),icon:const Icon(Icons.add),label:const Text('발급 대상자 추가'),style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(50),foregroundColor:GoneColors.primary)),
    const SizedBox(height:12), Row(children:[OutlinedButton(onPressed:c.clear,child:const Text('전체 삭제')),const SizedBox(width:12),Expanded(child:FilledButton(onPressed:state.students.isEmpty?null:(){final records=c.issueAll();ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('${records.length}명 점수 발급이 완료되었습니다.')));},style:FilledButton.styleFrom(minimumSize:const Size.fromHeight(52),backgroundColor:GoneColors.primary),child:const Text('점수 발급')))])
  ]); }
  void _pick(BuildContext context, PointSystemNotifier c) { showModalBottomSheet(context:context,builder:(_)=>ListView(children: mockPointStudents.map((s)=>ListTile(title:Text('${s.id} ${s.name}'),subtitle:Text(s.info),trailing:const Icon(Icons.add_circle,color:GoneColors.primary),onTap:(){c.addStudent(s);Navigator.pop(context);})).toList())); }
}

class _HistoryTab extends StatelessWidget { const _HistoryTab({required this.records}); final List<PointIssueRecord> records; @override Widget build(BuildContext context)=>records.isEmpty?const Center(child:Text('발급 내역이 없어요')):ListView(children:records.map((r)=>Card(child:ListTile(leading:Text('${r.draft.kind.prefix}${r.draft.points}',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold,color:r.draft.kind==PointKind.reward?GoneColors.success:GoneColors.error)),title:Text(r.student.name),subtitle:Text(r.draft.item))).toList()); }
class _StatisticsTab extends StatelessWidget { const _StatisticsTab({required this.records}); final List<PointIssueRecord> records; @override Widget build(BuildContext context){ final reward=records.where((r)=>r.draft.kind==PointKind.reward).fold(0,(a,b)=>a+b.draft.points); final penalty=records.where((r)=>r.draft.kind==PointKind.penalty).fold(0,(a,b)=>a+b.draft.points); return Row(children:[_stat('이번 달 발급','${records.length}',GoneColors.primary),_stat('발급한 상점','$reward',GoneColors.success),_stat('발급한 벌점','$penalty',GoneColors.error)]); } Widget _stat(String title,String value,Color color)=>Expanded(child:Container(height:76,margin:const EdgeInsets.only(right:6),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:11,color:Color(0xFF667085))),Text(value,style:TextStyle(fontSize:24,fontWeight:FontWeight.bold,color:color))]))); }
