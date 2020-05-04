enum Endpoint {
  cases,
  casesSuspected,
  casesConfirmed,
  deaths,
  recovered,
}

extension EndpointName on Endpoint {
  String get name => _endpointNames[this];
}

const Map<Endpoint, String> _endpointNames = {
  Endpoint.cases: 'cases',
  Endpoint.casesSuspected: 'casesSuspected',
  Endpoint.casesConfirmed: 'casesConfirmed',
  Endpoint.deaths: 'deaths',
  Endpoint.recovered: 'recovered',
};
