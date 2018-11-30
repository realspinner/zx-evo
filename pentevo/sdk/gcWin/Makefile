TARGET      := gcWin

#The Directories, Source, Includes, Objects, Binary and ReCXXSRC
SRCDIR      := src
BUILDDIR    := obj
TARGETDIR   := bin
RESDIR      := res

ASMEXT      := s
CXXEXT      := c
OBJEXT      := rel
HEXEXT      := hex
OUTEXT      := spg

#Flags, Libraries and Includes
LIB         := -L$(LIBDIR) -static-libstdc++ -lm -pthread -lwsutils -lstdc++fs -lmosquitto -llog4cpp -lcontracts -lprotobuf

ASMFLAGS    := -g
CXXFLAGS    := --std-c11 -mz80 --no-std-crt0 --opt-code-speed
LNKFLAGS    := --std-c11 -mz80 --no-std-crt0 --opt-code-speed -Wl-b_CODE=0x0200 -Wl-b_DATA=0xB000

#---------------------------------------------------------------------------------
#DO NOT EDIT BELOW THIS LINE
#---------------------------------------------------------------------------------
CXX         := c:\Tools\PROG\SDCC\bin\sdcc.exe
ASM         := c:\Tools\PROG\SDCC\bin\sdasz80

ASMSRC      := $(wildcard src/*.$(ASMEXT))
CXXSRC      := $(wildcard src/*.$(CXXEXT))
OBJECTS     := $(patsubst $(SRCDIR)/%, $(BUILDDIR)/%, $(ASMSRC:.$(ASMEXT)=.$(OBJEXT)))
OBJECTS     += $(patsubst $(SRCDIR)/%, $(BUILDDIR)/%, $(CXXSRC:.$(CXXEXT)=.$(OBJEXT)))
STRIP       := strip

#Defauilt Make
all: $(TARGET)

#Make the Directories
directories:
	@mkdir -p $(TARGETDIR)
	@mkdir -p $(BUILDDIR)

#Clean only Objects
clean:
	# $(foreach obj, $(OBJECTS), $(RM) -f $(obj))
	@$(RM) -rf $(BUILDDIR)
	@$(RM) -rf $(TARGETDIR)
	@$(RM) -rf $(TARGET).$(OUTEXT)

#Link
$(TARGET): $(OBJECTS)
	mkdir -p $(TARGETDIR)
	$(CXX) -o $(TARGETDIR)\$(TARGET).$(HEXEXT) $(LNKFLAGS) $^
	hex2bin -e bin $(TARGETDIR)\$(TARGET).$(HEXEXT)
	spgbld -b $(RESDIR)\spg.ini $(TARGET).$(OUTEXT)

#Compile C
$(BUILDDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(CXXEXT)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

#Compile ASM
$(BUILDDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(ASMEXT)
	@mkdir -p $(dir $@)
	$(ASM) $(ASMFLAGS) -o $@ $<

print-%  : ; @echo $* = $($*)

#Non-File Targets
.PHONY: all clean