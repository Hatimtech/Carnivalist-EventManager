class FormPayloadAnswers {
  String questionName;
  String answer;

  FormPayloadAnswers.fromJson(Map<String, dynamic> json) {
    questionName = json['questionName'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questionName != null) data['questionName'] = this.questionName;
    if (this.answer != null) data['answer'] = this.answer;
    return data;
  }
}
