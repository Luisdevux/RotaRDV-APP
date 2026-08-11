// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viagem_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetViagemCollectionCollection on Isar {
  IsarCollection<ViagemCollection> get viagemCollections => this.collection();
}

const ViagemCollectionSchema = CollectionSchema(
  name: r'ViagemCollection',
  id: -4688342346143694182,
  properties: {
    r'dataFim': PropertySchema(
      id: 0,
      name: r'dataFim',
      type: IsarType.dateTime,
    ),
    r'dataInicio': PropertySchema(
      id: 1,
      name: r'dataInicio',
      type: IsarType.dateTime,
    ),
    r'destinoCidade': PropertySchema(
      id: 2,
      name: r'destinoCidade',
      type: IsarType.string,
    ),
    r'destinoEstado': PropertySchema(
      id: 3,
      name: r'destinoEstado',
      type: IsarType.string,
    ),
    r'kmFinal': PropertySchema(
      id: 4,
      name: r'kmFinal',
      type: IsarType.double,
    ),
    r'kmInicial': PropertySchema(
      id: 5,
      name: r'kmInicial',
      type: IsarType.double,
    ),
    r'origemCidade': PropertySchema(
      id: 6,
      name: r'origemCidade',
      type: IsarType.string,
    ),
    r'origemEstado': PropertySchema(
      id: 7,
      name: r'origemEstado',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.string,
    ),
    r'statusSincronizacao': PropertySchema(
      id: 9,
      name: r'statusSincronizacao',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 10,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _viagemCollectionEstimateSize,
  serialize: _viagemCollectionSerialize,
  deserialize: _viagemCollectionDeserialize,
  deserializeProp: _viagemCollectionDeserializeProp,
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
  getId: _viagemCollectionGetId,
  getLinks: _viagemCollectionGetLinks,
  attach: _viagemCollectionAttach,
  version: '3.1.0+1',
);

int _viagemCollectionEstimateSize(
  ViagemCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.destinoCidade.length * 3;
  bytesCount += 3 + object.destinoEstado.length * 3;
  bytesCount += 3 + object.origemCidade.length * 3;
  bytesCount += 3 + object.origemEstado.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.statusSincronizacao.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _viagemCollectionSerialize(
  ViagemCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dataFim);
  writer.writeDateTime(offsets[1], object.dataInicio);
  writer.writeString(offsets[2], object.destinoCidade);
  writer.writeString(offsets[3], object.destinoEstado);
  writer.writeDouble(offsets[4], object.kmFinal);
  writer.writeDouble(offsets[5], object.kmInicial);
  writer.writeString(offsets[6], object.origemCidade);
  writer.writeString(offsets[7], object.origemEstado);
  writer.writeString(offsets[8], object.status);
  writer.writeString(offsets[9], object.statusSincronizacao);
  writer.writeString(offsets[10], object.uuid);
}

ViagemCollection _viagemCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ViagemCollection();
  object.dataFim = reader.readDateTimeOrNull(offsets[0]);
  object.dataInicio = reader.readDateTime(offsets[1]);
  object.destinoCidade = reader.readString(offsets[2]);
  object.destinoEstado = reader.readString(offsets[3]);
  object.id = id;
  object.kmFinal = reader.readDoubleOrNull(offsets[4]);
  object.kmInicial = reader.readDouble(offsets[5]);
  object.origemCidade = reader.readString(offsets[6]);
  object.origemEstado = reader.readString(offsets[7]);
  object.status = reader.readString(offsets[8]);
  object.statusSincronizacao = reader.readString(offsets[9]);
  object.uuid = reader.readString(offsets[10]);
  return object;
}

P _viagemCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _viagemCollectionGetId(ViagemCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _viagemCollectionGetLinks(ViagemCollection object) {
  return [];
}

void _viagemCollectionAttach(
    IsarCollection<dynamic> col, Id id, ViagemCollection object) {
  object.id = id;
}

extension ViagemCollectionByIndex on IsarCollection<ViagemCollection> {
  Future<ViagemCollection?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  ViagemCollection? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<ViagemCollection?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<ViagemCollection?> getAllByUuidSync(List<String> uuidValues) {
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

  Future<Id> putByUuid(ViagemCollection object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(ViagemCollection object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<ViagemCollection> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<ViagemCollection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension ViagemCollectionQueryWhereSort
    on QueryBuilder<ViagemCollection, ViagemCollection, QWhere> {
  QueryBuilder<ViagemCollection, ViagemCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ViagemCollectionQueryWhere
    on QueryBuilder<ViagemCollection, ViagemCollection, QWhereClause> {
  QueryBuilder<ViagemCollection, ViagemCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterWhereClause>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterWhereClause> idBetween(
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterWhereClause>
      uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterWhereClause>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterWhereClause>
      statusSincronizacaoEqualTo(String statusSincronizacao) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'statusSincronizacao',
        value: [statusSincronizacao],
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterWhereClause>
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

extension ViagemCollectionQueryFilter
    on QueryBuilder<ViagemCollection, ViagemCollection, QFilterCondition> {
  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      dataFimIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataFim',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      dataFimIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataFim',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      dataFimEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataFim',
        value: value,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      dataFimGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataFim',
        value: value,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      dataFimLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataFim',
        value: value,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      dataFimBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataFim',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      dataInicioEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataInicio',
        value: value,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      dataInicioGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataInicio',
        value: value,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      dataInicioLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataInicio',
        value: value,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      dataInicioBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataInicio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoCidadeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinoCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoCidadeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'destinoCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoCidadeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'destinoCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoCidadeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'destinoCidade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoCidadeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'destinoCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoCidadeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'destinoCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoCidadeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'destinoCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoCidadeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'destinoCidade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoCidadeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinoCidade',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoCidadeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'destinoCidade',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoEstadoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinoEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoEstadoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'destinoEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoEstadoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'destinoEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoEstadoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'destinoEstado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoEstadoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'destinoEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoEstadoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'destinoEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoEstadoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'destinoEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoEstadoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'destinoEstado',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoEstadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinoEstado',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      destinoEstadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'destinoEstado',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      kmFinalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'kmFinal',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      kmFinalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'kmFinal',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      kmFinalEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kmFinal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      kmFinalGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kmFinal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      kmFinalLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kmFinal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      kmFinalBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kmFinal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      kmInicialEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kmInicial',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      kmInicialGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kmInicial',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      kmInicialLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kmInicial',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      kmInicialBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kmInicial',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemCidadeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'origemCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemCidadeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'origemCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemCidadeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'origemCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemCidadeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'origemCidade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemCidadeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'origemCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemCidadeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'origemCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemCidadeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'origemCidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemCidadeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'origemCidade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemCidadeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'origemCidade',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemCidadeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'origemCidade',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemEstadoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'origemEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemEstadoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'origemEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemEstadoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'origemEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemEstadoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'origemEstado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemEstadoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'origemEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemEstadoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'origemEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemEstadoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'origemEstado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemEstadoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'origemEstado',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemEstadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'origemEstado',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      origemEstadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'origemEstado',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusSincronizacaoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statusSincronizacao',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusSincronizacaoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statusSincronizacao',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusSincronizacaoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusSincronizacao',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      statusSincronizacaoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statusSincronizacao',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
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

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension ViagemCollectionQueryObject
    on QueryBuilder<ViagemCollection, ViagemCollection, QFilterCondition> {}

extension ViagemCollectionQueryLinks
    on QueryBuilder<ViagemCollection, ViagemCollection, QFilterCondition> {}

extension ViagemCollectionQuerySortBy
    on QueryBuilder<ViagemCollection, ViagemCollection, QSortBy> {
  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByDataFim() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataFim', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByDataFimDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataFim', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByDataInicio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataInicio', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByDataInicioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataInicio', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByDestinoCidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinoCidade', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByDestinoCidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinoCidade', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByDestinoEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinoEstado', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByDestinoEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinoEstado', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByKmFinal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmFinal', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByKmFinalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmFinal', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByKmInicial() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmInicial', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByKmInicialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmInicial', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByOrigemCidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origemCidade', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByOrigemCidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origemCidade', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByOrigemEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origemEstado', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByOrigemEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origemEstado', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByStatusSincronizacao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusSincronizacao', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByStatusSincronizacaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusSincronizacao', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ViagemCollectionQuerySortThenBy
    on QueryBuilder<ViagemCollection, ViagemCollection, QSortThenBy> {
  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByDataFim() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataFim', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByDataFimDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataFim', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByDataInicio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataInicio', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByDataInicioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataInicio', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByDestinoCidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinoCidade', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByDestinoCidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinoCidade', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByDestinoEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinoEstado', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByDestinoEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinoEstado', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByKmFinal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmFinal', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByKmFinalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmFinal', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByKmInicial() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmInicial', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByKmInicialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kmInicial', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByOrigemCidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origemCidade', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByOrigemCidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origemCidade', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByOrigemEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origemEstado', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByOrigemEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'origemEstado', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByStatusSincronizacao() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusSincronizacao', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByStatusSincronizacaoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusSincronizacao', Sort.desc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension ViagemCollectionQueryWhereDistinct
    on QueryBuilder<ViagemCollection, ViagemCollection, QDistinct> {
  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct>
      distinctByDataFim() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataFim');
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct>
      distinctByDataInicio() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataInicio');
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct>
      distinctByDestinoCidade({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destinoCidade',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct>
      distinctByDestinoEstado({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destinoEstado',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct>
      distinctByKmFinal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kmFinal');
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct>
      distinctByKmInicial() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kmInicial');
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct>
      distinctByOrigemCidade({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'origemCidade', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct>
      distinctByOrigemEstado({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'origemEstado', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct>
      distinctByStatusSincronizacao({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusSincronizacao',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ViagemCollection, ViagemCollection, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension ViagemCollectionQueryProperty
    on QueryBuilder<ViagemCollection, ViagemCollection, QQueryProperty> {
  QueryBuilder<ViagemCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ViagemCollection, DateTime?, QQueryOperations>
      dataFimProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataFim');
    });
  }

  QueryBuilder<ViagemCollection, DateTime, QQueryOperations>
      dataInicioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataInicio');
    });
  }

  QueryBuilder<ViagemCollection, String, QQueryOperations>
      destinoCidadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destinoCidade');
    });
  }

  QueryBuilder<ViagemCollection, String, QQueryOperations>
      destinoEstadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destinoEstado');
    });
  }

  QueryBuilder<ViagemCollection, double?, QQueryOperations> kmFinalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kmFinal');
    });
  }

  QueryBuilder<ViagemCollection, double, QQueryOperations> kmInicialProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kmInicial');
    });
  }

  QueryBuilder<ViagemCollection, String, QQueryOperations>
      origemCidadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'origemCidade');
    });
  }

  QueryBuilder<ViagemCollection, String, QQueryOperations>
      origemEstadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'origemEstado');
    });
  }

  QueryBuilder<ViagemCollection, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<ViagemCollection, String, QQueryOperations>
      statusSincronizacaoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusSincronizacao');
    });
  }

  QueryBuilder<ViagemCollection, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
