// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'despesa_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDespesaCollectionCollection on Isar {
  IsarCollection<DespesaCollection> get despesaCollections => this.collection();
}

const DespesaCollectionSchema = CollectionSchema(
  name: r'DespesaCollection',
  id: 2808925843699576456,
  properties: {
    r'data': PropertySchema(
      id: 0,
      name: r'data',
      type: IsarType.dateTime,
    ),
    r'descricao': PropertySchema(
      id: 1,
      name: r'descricao',
      type: IsarType.string,
    ),
    r'fotoAnexoLocalPath': PropertySchema(
      id: 2,
      name: r'fotoAnexoLocalPath',
      type: IsarType.string,
    ),
    r'fotoAnexoUrl': PropertySchema(
      id: 3,
      name: r'fotoAnexoUrl',
      type: IsarType.string,
    ),
    r'fotoTiradaNoApp': PropertySchema(
      id: 4,
      name: r'fotoTiradaNoApp',
      type: IsarType.bool,
    ),
    r'kmAtual': PropertySchema(
      id: 5,
      name: r'kmAtual',
      type: IsarType.double,
    ),
    r'litros': PropertySchema(
      id: 6,
      name: r'litros',
      type: IsarType.double,
    ),
    r'local': PropertySchema(
      id: 7,
      name: r'local',
      type: IsarType.string,
    ),
    r'statusSincronizacao': PropertySchema(
      id: 8,
      name: r'statusSincronizacao',
      type: IsarType.string,
    ),
    r'tipo': PropertySchema(
      id: 9,
      name: r'tipo',
      type: IsarType.string,
    ),
    r'tipoCombustivel': PropertySchema(
      id: 10,
      name: r'tipoCombustivel',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 11,
      name: r'uuid',
      type: IsarType.string,
    ),
    r'valorLitro': PropertySchema(
      id: 12,
      name: r'valorLitro',
      type: IsarType.double,
    ),
    r'valorTotal': PropertySchema(
      id: 13,
      name: r'valorTotal',
      type: IsarType.double,
    ),
    r'viagemId': PropertySchema(
      id: 14,
      name: r'viagemId',
      type: IsarType.string,
    )
  },
  estimateSize: _despesaCollectionEstimateSize,
  serialize: _despesaCollectionSerialize,
  deserialize: _despesaCollectionDeserialize,
  deserializeProp: _despesaCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'viagemId': IndexSchema(
      id: 2982983543883363683,
      name: r'viagemId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'viagemId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'statusSincronizacao': IndexSchema(
      id: -7195281045241055754,
      name: r'statusSincronizacao',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'statusSincronizacao',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _despesaCollectionGetId,
  getLinks: _despesaCollectionGetLinks,
  attach: _despesaCollectionAttach,
  version: '3.1.0+1',
);

int _despesaCollectionEstimateSize(
  DespesaCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.descricao;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fotoAnexoLocalPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fotoAnexoUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.local;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.statusSincronizacao.length * 3;
  bytesCount += 3 + object.tipo.length * 3;
  {
    final value = object.tipoCombustivel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.uuid.length * 3;
  bytesCount += 3 + object.viagemId.length * 3;
  return bytesCount;
}

void _despesaCollectionSerialize(
  DespesaCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.data);
  writer.writeString(offsets[1], object.descricao);
  writer.writeString(offsets[2], object.fotoAnexoLocalPath);
  writer.writeString(offsets[3], object.fotoAnexoUrl);
  writer.writeBool(offsets[4], object.fotoTiradaNoApp);
  writer.writeDouble(offsets[5], object.kmAtual);
  writer.writeDouble(offsets[6], object.litros);
  writer.writeString(offsets[7], object.local);
  writer.writeString(offsets[8], object.statusSincronizacao);
  writer.writeString(offsets[9], object.tipo);
  writer.writeString(offsets[10], object.tipoCombustivel);
  writer.writeString(offsets[11], object.uuid);
  writer.writeDouble(offsets[12], object.valorLitro);
  writer.writeDouble(offsets[13], object.valorTotal);
  writer.writeString(offsets[14], object.viagemId);
}

DespesaCollection _despesaCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DespesaCollection();
  object.data = reader.readDateTime(offsets[0]);
  object.descricao = reader.readStringOrNull(offsets[1]);
  object.fotoAnexoLocalPath = reader.readStringOrNull(offsets[2]);
  object.fotoAnexoUrl = reader.readStringOrNull(offsets[3]);
  object.fotoTiradaNoApp = reader.readBoolOrNull(offsets[4]);
  object.id = id;
  object.kmAtual = reader.readDoubleOrNull(offsets[5]);
  object.litros = reader.readDoubleOrNull(offsets[6]);
  object.local = reader.readStringOrNull(offsets[7]);
  object.statusSincronizacao = reader.readString(offsets[8]);
  object.tipo = reader.readString(offsets[9]);
  object.tipoCombustivel = reader.readStringOrNull(offsets[10]);
  object.uuid = reader.readString(offsets[11]);
  object.valorLitro = reader.readDoubleOrNull(offsets[12]);
  object.valorTotal = reader.readDouble(offsets[13]);
  object.viagemId = reader.readString(offsets[14]);
  return object;
}

P _despesaCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDoubleOrNull(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _despesaCollectionGetId(DespesaCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _despesaCollectionGetLinks(
    DespesaCollection object) {
  return [];
}

void _despesaCollectionAttach(
    IsarCollection<dynamic> col, Id id, DespesaCollection object) {
  object.id = id;
}

extension DespesaCollectionByIndex on IsarCollection<DespesaCollection> {
  Future<DespesaCollection?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  DespesaCollection? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<DespesaCollection?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<DespesaCollection?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(DespesaCollection object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(DespesaCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<DespesaCollection> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<DespesaCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension DespesaCollectionQueryWhereSort
    on QueryBuilder<DespesaCollection, DespesaCollection, QWhere> {
  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DespesaCollectionQueryWhere
    on QueryBuilder<DespesaCollection, DespesaCollection, QWhereClause> {
  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      viagemIdEqualTo(String viagemId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'viagemId',
        value: [viagemId],
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      viagemIdNotEqualTo(String viagemId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'viagemId',
              lower: [],
              upper: [viagemId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'viagemId',
              lower: [viagemId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'viagemId',
              lower: [viagemId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'viagemId',
              lower: [],
              upper: [viagemId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      statusSincronizacaoEqualTo(String statusSincronizacao) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'statusSincronizacao',
        value: [statusSincronizacao],
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterWhereClause>
      statusSincronizacaoNotEqualTo(String statusSincronizacao) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusSincronizacao',
              lower: [],
              upper: [statusSincronizacao],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusSincronizacao',
              lower: [statusSincronizacao],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusSincronizacao',
              lower: [statusSincronizacao],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusSincronizacao',
              lower: [],
              upper: [statusSincronizacao],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DespesaCollectionQueryFilter
    on QueryBuilder<DespesaCollection, DespesaCollection, QFilterCondition> {
  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      dataEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: value,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      dataGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'data',
        value: value,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      dataLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'data',
        value: value,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      dataBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'data',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'descricao',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'descricao',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descricao',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descricao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descricao',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descricao',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      descricaoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descricao',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fotoAnexoLocalPath',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fotoAnexoLocalPath',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fotoAnexoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fotoAnexoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fotoAnexoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fotoAnexoLocalPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fotoAnexoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fotoAnexoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fotoAnexoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fotoAnexoLocalPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fotoAnexoLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoLocalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fotoAnexoLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fotoAnexoUrl',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fotoAnexoUrl',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fotoAnexoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fotoAnexoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fotoAnexoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fotoAnexoUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fotoAnexoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fotoAnexoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fotoAnexoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fotoAnexoUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fotoAnexoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoAnexoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fotoAnexoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoTiradaNoAppIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fotoTiradaNoApp',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoTiradaNoAppIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fotoTiradaNoApp',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      fotoTiradaNoAppEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fotoTiradaNoApp',
        value: value,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      kmAtualIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kmAtual',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      kmAtualIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kmAtual',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      kmAtualEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kmAtual',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      kmAtualGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kmAtual',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      kmAtualLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kmAtual',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      kmAtualBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kmAtual',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      litrosIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'litros',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      litrosIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'litros',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      litrosEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'litros',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      litrosGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'litros',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      litrosLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'litros',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      litrosBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'litros',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'local',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'local',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'local',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'local',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'local',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      localIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'local',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      statusSincronizacaoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusSincronizacao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      statusSincronizacaoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusSincronizacao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      statusSincronizacaoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusSincronizacao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      statusSincronizacaoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusSincronizacao',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      statusSincronizacaoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statusSincronizacao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      statusSincronizacaoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statusSincronizacao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      statusSincronizacaoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statusSincronizacao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      statusSincronizacaoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statusSincronizacao',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      statusSincronizacaoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusSincronizacao',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      statusSincronizacaoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statusSincronizacao',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tipo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tipo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipo',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tipo',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tipoCombustivel',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tipoCombustivel',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipoCombustivel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipoCombustivel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipoCombustivel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipoCombustivel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tipoCombustivel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tipoCombustivel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tipoCombustivel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tipoCombustivel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipoCombustivel',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      tipoCombustivelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tipoCombustivel',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      valorLitroIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'valorLitro',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      valorLitroIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'valorLitro',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      valorLitroEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valorLitro',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      valorLitroGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valorLitro',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      valorLitroLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valorLitro',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      valorLitroBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valorLitro',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      valorTotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valorTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      valorTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valorTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      valorTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valorTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      valorTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valorTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      viagemIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'viagemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      viagemIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'viagemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      viagemIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'viagemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      viagemIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'viagemId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      viagemIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'viagemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      viagemIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'viagemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      viagemIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'viagemId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      viagemIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'viagemId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      viagemIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'viagemId',
        value: '',
      ));
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterFilterCondition>
      viagemIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'viagemId',
        value: '',
      ));
    });
  }
}

extension DespesaCollectionQueryObject
    on QueryBuilder<DespesaCollection, DespesaCollection, QFilterCondition> {}

extension DespesaCollectionQueryLinks
    on QueryBuilder<DespesaCollection, DespesaCollection, QFilterCondition> {}

extension DespesaCollectionQuerySortBy
    on QueryBuilder<DespesaCollection, DespesaCollection, QSortBy> {
  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByDescricao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descricao', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByDescricaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descricao', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByFotoAnexoLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoAnexoLocalPath', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByFotoAnexoLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoAnexoLocalPath', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByFotoAnexoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoAnexoUrl', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByFotoAnexoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoAnexoUrl', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByFotoTiradaNoApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoTiradaNoApp', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByFotoTiradaNoAppDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoTiradaNoApp', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByKmAtual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmAtual', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByKmAtualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmAtual', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByLitros() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'litros', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByLitrosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'litros', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'local', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'local', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByStatusSincronizacao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusSincronizacao', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByStatusSincronizacaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusSincronizacao', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByTipo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByTipoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByTipoCombustivel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoCombustivel', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByTipoCombustivelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoCombustivel', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByValorLitro() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorLitro', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByValorLitroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorLitro', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByValorTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorTotal', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByValorTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorTotal', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByViagemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viagemId', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      sortByViagemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viagemId', Sort.desc);
    });
  }
}

extension DespesaCollectionQuerySortThenBy
    on QueryBuilder<DespesaCollection, DespesaCollection, QSortThenBy> {
  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByDescricao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descricao', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByDescricaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descricao', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByFotoAnexoLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoAnexoLocalPath', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByFotoAnexoLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoAnexoLocalPath', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByFotoAnexoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoAnexoUrl', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByFotoAnexoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoAnexoUrl', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByFotoTiradaNoApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoTiradaNoApp', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByFotoTiradaNoAppDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoTiradaNoApp', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByKmAtual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmAtual', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByKmAtualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmAtual', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByLitros() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'litros', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByLitrosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'litros', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'local', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'local', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByStatusSincronizacao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusSincronizacao', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByStatusSincronizacaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusSincronizacao', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByTipo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByTipoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipo', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByTipoCombustivel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoCombustivel', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByTipoCombustivelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoCombustivel', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByValorLitro() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorLitro', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByValorLitroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorLitro', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByValorTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorTotal', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByValorTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorTotal', Sort.desc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByViagemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viagemId', Sort.asc);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QAfterSortBy>
      thenByViagemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viagemId', Sort.desc);
    });
  }
}

extension DespesaCollectionQueryWhereDistinct
    on QueryBuilder<DespesaCollection, DespesaCollection, QDistinct> {
  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'data');
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByDescricao({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'descricao', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByFotoAnexoLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fotoAnexoLocalPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByFotoAnexoUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fotoAnexoUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByFotoTiradaNoApp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fotoTiradaNoApp');
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByKmAtual() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kmAtual');
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByLitros() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'litros');
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct> distinctByLocal(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'local', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByStatusSincronizacao({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusSincronizacao',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct> distinctByTipo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByTipoCombustivel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipoCombustivel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByValorLitro() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valorLitro');
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByValorTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valorTotal');
    });
  }

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct>
      distinctByViagemId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'viagemId', caseSensitive: caseSensitive);
    });
  }
}

extension DespesaCollectionQueryProperty
    on QueryBuilder<DespesaCollection, DespesaCollection, QQueryProperty> {
  QueryBuilder<DespesaCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DespesaCollection, DateTime, QQueryOperations> dataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'data');
    });
  }

  QueryBuilder<DespesaCollection, String?, QQueryOperations>
      descricaoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descricao');
    });
  }

  QueryBuilder<DespesaCollection, String?, QQueryOperations>
      fotoAnexoLocalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fotoAnexoLocalPath');
    });
  }

  QueryBuilder<DespesaCollection, String?, QQueryOperations>
      fotoAnexoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fotoAnexoUrl');
    });
  }

  QueryBuilder<DespesaCollection, bool?, QQueryOperations>
      fotoTiradaNoAppProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fotoTiradaNoApp');
    });
  }

  QueryBuilder<DespesaCollection, double?, QQueryOperations> kmAtualProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kmAtual');
    });
  }

  QueryBuilder<DespesaCollection, double?, QQueryOperations> litrosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'litros');
    });
  }

  QueryBuilder<DespesaCollection, String?, QQueryOperations> localProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'local');
    });
  }

  QueryBuilder<DespesaCollection, String, QQueryOperations>
      statusSincronizacaoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusSincronizacao');
    });
  }

  QueryBuilder<DespesaCollection, String, QQueryOperations> tipoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipo');
    });
  }

  QueryBuilder<DespesaCollection, String?, QQueryOperations>
      tipoCombustivelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipoCombustivel');
    });
  }

  QueryBuilder<DespesaCollection, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<DespesaCollection, double?, QQueryOperations>
      valorLitroProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valorLitro');
    });
  }

  QueryBuilder<DespesaCollection, double, QQueryOperations>
      valorTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valorTotal');
    });
  }

  QueryBuilder<DespesaCollection, String, QQueryOperations> viagemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'viagemId');
    });
  }
}
