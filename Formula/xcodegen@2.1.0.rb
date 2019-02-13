class XcodegenAT210 < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.1.0.tar.gz"
  sha256 "b7895b8daacb7cef19e8dd3518ac060e9d9ba99479aff4a5b6ca44f7326099da"
  version "2.1.0"

  # bottle do
  #   root_url "https://artifacts-generic.groupondev.com/mobile/bottles-mobile"
  #   cellar :any_skip_relocation
  #   sha256 "f53875de6521b7b7fe94a13e9e5fa935165c70de92b78fc8455afdaabd63099a" => :mojave
  #   sha256 "7b8a0f99b291777d57ebfdd0b65302263f93d7abcf29e2bdca2158fb5644d2dd" => :high_sierra
  # end
  
  depends_on :xcode => ["9.3", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"xcodegen.yml").write <<~EOS
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    EOS
    (testpath/"TestProject").mkpath
    system bin/"XcodeGen", "--spec", testpath/"xcodegen.yml"
    assert_predicate testpath/"GeneratedProject.xcodeproj", :exist?
    assert_predicate testpath/"GeneratedProject.xcodeproj/project.pbxproj", :exist?
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end
