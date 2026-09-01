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
    r'local': PropertySchema(
      id: 3,
      name: r'local',
      type: IsarType.string,
    ),
    r'statusSincronizacao': PropertySchema(
      id: 4,
      name: r'statusSincronizacao',
      type: IsarType.string,
    ),
    r'tipo': PropertySchema(
      id: 5,
      name: r'tipo',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 6,
      name: r'uuid',
      type: IsarType.string,
    ),
    r'valorTotal': PropertySchema(
      id: 7,
      name: r'valorTotal',
      type: IsarType.double,
    ),
    r'viagemId': PropertySchema(
      id: 8,
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
    final value = object.local;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.statusSincronizacao.length * 3;
  bytesCount += 3 + object.tipo.length * 3;
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
  writer.writeString(offsets[3], object.local);
  writer.writeString(offsets[4], object.statusSincronizacao);
  writer.writeString(offsets[5], object.tipo);
  writer.writeString(offsets[6], object.uuid);
  writer.writeDouble(offsets[7], object.valorTotal);
  writer.writeString(offsets[8], object.viagemId);
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
  object.id = id;
  object.local = reader.readStringOrNull(offsets[3]);
  object.statusSincronizacao = reader.readString(offsets[4]);
  object.tipo = reader.readString(offsets[5]);
  object.uuid = reader.readString(offsets[6]);
  object.valorTotal = reader.readDouble(offsets[7]);
  object.viagemId = reader.readString(offsets[8]);
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
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
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

  QueryBuilder<DespesaCollection, DespesaCollection, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
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

  QueryBuilder<DespesaCollection, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
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
