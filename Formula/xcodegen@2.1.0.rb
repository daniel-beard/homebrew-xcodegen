class XcodegenAT210 < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://github.com/yonaskolb/XcodeGen/archive/2.1.0.tar.gz"
  sha256 "b7895b8daacb7cef19e8dd3518ac060e9d9ba99479aff4a5b6ca44f7326099da"
  version "2.1.0"

  bottle do
    root_url "https://github.com/daniel-beard/homebrew-xcodegen/raw/master/bottles"
    cellar :any_skip_relocation
    sha256 "29fbfde654ab43730cb878294e021b2ba1cd8a41e9c23bd1006541e7d4de3e1f" => :mojave
  end
  
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
