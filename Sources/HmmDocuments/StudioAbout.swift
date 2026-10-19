#if canImport(SwiftUI)
    import HmmDesign
    import SwiftUI

    /// A Studio's About page: the thing's name, who made it and what others may do with it when it's shared as a pack.
    /// A thing that came in a pack shows where from, in one line.
    public struct HmmStudioAbout: View {
        @Binding private var name: String
        @Binding private var author: String
        @Binding private var licence: HmmLicence
        private let origin: HmmPackOrigin?
        @Environment(\.hmmTheme) private var theme

        public init(name: Binding<String>, author: Binding<String>, licence: Binding<HmmLicence>, origin: HmmPackOrigin? = nil) {
            _name = name
            _author = author
            _licence = licence
            self.origin = origin
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: HmmSpacing.s) {
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("studio-name")
                TextField("Author", text: $author)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityIdentifier("studio-author")
                HmmLicencePicker(licence: $licence)
                Text(verbatim: licence.sentence(author: author))
                    .font(.hmm(.footnote))
                    .foregroundStyle(theme.text2)
                if let origin {
                    Text("From “\(origin.pack)” by \(origin.author)")
                        .font(.hmm(.footnote, weight: .semibold))
                        .foregroundStyle(theme.text2)
                }
            }
        }
    }

    /// What others may do with a shared thing: four choices in words, the last one the author's own.
    public struct HmmLicencePicker: View {
        @Binding private var licence: HmmLicence

        public init(licence: Binding<HmmLicence>) {
            _licence = licence
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: HmmSpacing.xs) {
                Picker("Others may", selection: Binding(get: { kind(of: licence) }, set: { licence = choice($0) })) {
                    ForEach(HmmLicence.choices.indices, id: \.self) { index in
                        Text(LocalizedStringKey(HmmLicence.choices[index].title)).tag(index)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityIdentifier("studio-licence")
                if case let .own(text) = licence {
                    TextField("In your own words", text: Binding(get: { text }, set: { licence = .own($0) }), axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(2 ... 4)
                }
            }
        }

        private func kind(of licence: HmmLicence) -> Int {
            HmmLicence.choices.firstIndex { $0.sameKind(as: licence) } ?? 0
        }

        private func choice(_ index: Int) -> HmmLicence {
            let picked = HmmLicence.choices[min(max(index, 0), HmmLicence.choices.count - 1)]
            if case .own = picked, case let .own(text) = licence { return .own(text) }
            return picked
        }
    }
#endif
