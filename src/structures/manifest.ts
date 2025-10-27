export interface ManifestPublication {
  fileName: string;
  type: number;
  title: string;
  shortTitle: string;
  displayTitle: string;
  referenceTitle: string;
  undatedReferenceTitle: string;
  titleRich: string;
  displayTitleRich: string;
  referenceTitleRich: string;
  undatedReferenceTitleRich: string;
  symbol: string;
  uniqueEnglishSymbol: string;
  uniqueSymbol: string;
  englishSymbol: string;
  language: number;
  hash: string;
  timestamp: string;
  minPlatformVersion: number;
  schemaVersion: number;
  year: number;
  issueId: number;
  issueNumber: number;
  publicationType: string;
  rootSymbol: string;
  rootYear: number;
  rootLanguage: number;
  images: string[];
  categories: string[];
  attributes: string[];
}

export interface Manifest {
  name: string;
  hash: string;
  timestamp: string;
  version: number;
  expandedSize: number;
  contentFormat: string;
  htmlValidated: boolean;
  mepsPlatformVersion: number;
  mepsBuildNumber: number;
  publication: ManifestPublication;
}

export function createDefaultManifest(): Manifest {
  return {
    name: "",
    hash: "",
    timestamp: "",
    version: 1,
    expandedSize: 0,
    contentFormat: "z-a",
    htmlValidated: false,
    mepsPlatformVersion: 2.1,
    mepsBuildNumber: 12345,
    publication: {
      fileName: "",
      type: 1,
      title: "",
      shortTitle: "",
      displayTitle: "",
      referenceTitle: "",
      undatedReferenceTitle: "",
      titleRich: "",
      displayTitleRich: "",
      referenceTitleRich: "",
      undatedReferenceTitleRich: "",
      symbol: "",
      uniqueEnglishSymbol: "",
      uniqueSymbol: "",
      englishSymbol: "",
      language: 0,
      hash: "",
      timestamp: "",
      minPlatformVersion: 1,
      schemaVersion: 8,
      year: 0,
      issueId: 0,
      issueNumber: 0,
      publicationType: "Manual/Guidelines",
      rootSymbol: "",
      rootYear: 0,
      rootLanguage: 0,
      images: [],
      categories: ["manual"],
      attributes: [],
    },
  };
}
