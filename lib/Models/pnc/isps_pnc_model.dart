class ISPSPNCModel {
  String? value;
  String? name;

  ISPSPNCModel(
      {this.value,
        this.name
      });

  bool isEqual(ISPSPNCModel? model) {
    return this.value == model?.value;
  }
}